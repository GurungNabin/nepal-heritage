import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class ContentCardWidget extends StatefulWidget {
  const ContentCardWidget({
    super.key,
    required this.content,
    required this.onTap,
    required this.onBookmark,
    required this.onShare,
    this.isSelected = false,
  });

  final Map<String, dynamic> content;
  final VoidCallback onTap;
  final VoidCallback onBookmark;
  final VoidCallback onShare;
  final bool isSelected;

  @override
  State<ContentCardWidget> createState() => _ContentCardWidgetState();
}

class _ContentCardWidgetState extends State<ContentCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final content = widget.content;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onLongPress: () {
              // Handle multi-select mode activation
              HapticFeedback.mediumImpact();
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 2.h),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: widget.isSelected
                    ? Border.all(color: colorScheme.primary, width: 2)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMediaThumbnail(context, content),
                  _buildContentInfo(context, content),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMediaThumbnail(
      BuildContext context, Map<String, dynamic> content) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaType = content['type'] as String;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: AspectRatio(
            aspectRatio: _getAspectRatio(content),
            child: CustomImageWidget(
              imageUrl: content['thumbnail'] as String,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Media type indicator
        Positioned(
          top: 2.w,
          right: 2.w,
          child: Container(
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: _getMediaIcon(mediaType),
              color: Colors.white,
              size: 4.w,
            ),
          ),
        ),
        // Category badge
        Positioned(
          top: 2.w,
          left: 2.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              content['category'] as String,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        // Quick actions overlay (shown on swipe)
        if (_isPressed)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickAction(
                    context,
                    'bookmark',
                    'Bookmark',
                    widget.onBookmark,
                  ),
                  _buildQuickAction(
                    context,
                    'share',
                    'Share',
                    widget.onShare,
                  ),
                  _buildQuickAction(
                    context,
                    'download',
                    'Download',
                    () {
                      // Handle download
                    },
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String iconName,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: Colors.white,
              size: 6.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentInfo(BuildContext context, Map<String, dynamic> content) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content['title'] as String,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          if (content['description'] != null)
            Text(
              content['description'] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'visibility',
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: 4.w,
              ),
              SizedBox(width: 1.w),
              Text(
                '${content['views']}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(width: 4.w),
              CustomIconWidget(
                iconName: 'favorite_border',
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: 4.w,
              ),
              SizedBox(width: 1.w),
              Text(
                '${content['likes']}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const Spacer(),
              if (content['isBookmarked'] == true)
                CustomIconWidget(
                  iconName: 'bookmark',
                  color: colorScheme.primary,
                  size: 4.w,
                ),
            ],
          ),
        ],
      ),
    );
  }

  double _getAspectRatio(Map<String, dynamic> content) {
    final type = content['type'] as String;
    switch (type) {
      case 'video':
        return 16 / 9;
      case '3d_model':
        return 1.0;
      default:
        return 4 / 3;
    }
  }

  String _getMediaIcon(String mediaType) {
    switch (mediaType) {
      case 'video':
        return 'play_circle_outline';
      case '3d_model':
        return 'view_in_ar';
      case 'audio':
        return 'audiotrack';
      default:
        return 'image';
    }
  }
}