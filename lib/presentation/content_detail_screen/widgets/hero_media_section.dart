import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HeroMediaSection extends StatefulWidget {
  const HeroMediaSection({
    super.key,
    required this.mediaUrl,
    required this.mediaType,
    this.onBookmarkTap,
    this.onShareTap,
  });

  final String mediaUrl;
  final String mediaType; // 'image', 'video', '3d_model'
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onShareTap;

  @override
  State<HeroMediaSection> createState() => _HeroMediaSectionState();
}

class _HeroMediaSectionState extends State<HeroMediaSection> {
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 50.h,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Container(
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: CustomIconWidget(
              iconName: _isBookmarked ? 'bookmark' : 'bookmark_border',
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _isBookmarked = !_isBookmarked;
              });
              widget.onBookmarkTap?.call();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isBookmarked
                      ? 'Added to bookmarks'
                      : 'Removed from bookmarks'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
        Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: CustomIconWidget(
              iconName: 'share',
              color: Colors.white,
              size: 24,
            ),
            onPressed: widget.onShareTap,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _buildMediaContent(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent() {
    switch (widget.mediaType) {
      case 'video':
        return _buildVideoPlayer();
      case '3d_model':
        return _build3DModelViewer();
      case 'image':
      default:
        return CustomImageWidget(
          imageUrl: widget.mediaUrl,
          width: 100.w,
          height: 50.h,
          fit: BoxFit.cover,
        );
    }
  }

  Widget _buildVideoPlayer() {
    return Container(
      width: 100.w,
      height: 50.h,
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomImageWidget(
            imageUrl: widget.mediaUrl,
            width: 100.w,
            height: 50.h,
            fit: BoxFit.cover,
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(50),
            ),
            child: CustomIconWidget(
              iconName: 'play_arrow',
              color: Colors.white,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }

  Widget _build3DModelViewer() {
    return Container(
      width: 100.w,
      height: 50.h,
      color: AppTheme.lightTheme.colorScheme.surface,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomImageWidget(
            imageUrl: widget.mediaUrl,
            width: 100.w,
            height: 50.h,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 4.h,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'threed_rotation',
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '3D Model',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
