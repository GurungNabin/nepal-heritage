import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchResultCardWidget extends StatelessWidget {
  const SearchResultCardWidget({
    super.key,
    required this.result,
    required this.searchQuery,
    required this.onTap,
    required this.onBookmark,
    required this.onShare,
    required this.onViewSimilar,
  });

  final Map<String, dynamic> result;
  final String searchQuery;
  final VoidCallback onTap;
  final VoidCallback onBookmark;
  final VoidCallback onShare;
  final VoidCallback onViewSimilar;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(result['id']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onBookmark(),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            icon: Icons.bookmark_border,
            label: 'Bookmark',
          ),
          SlidableAction(
            onPressed: (_) => onShare(),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
            icon: Icons.share,
            label: 'Share',
          ),
          SlidableAction(
            onPressed: (_) => onViewSimilar(),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
            icon: Icons.explore,
            label: 'Similar',
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: result['thumbnail'] as String? ?? '',
                    width: 20.w,
                    height: 15.h,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(width: 3.w),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Content type badge
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getTypeColor(result['type'] as String? ?? ''),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          result['type'] as String? ?? '',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      SizedBox(height: 1.h),

                      // Title with highlighting
                      RichText(
                        text: _buildHighlightedText(
                          result['title'] as String? ?? '',
                          searchQuery,
                          AppTheme.lightTheme.textTheme.titleMedium!,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 0.5.h),

                      // Description snippet with highlighting
                      RichText(
                        text: _buildHighlightedText(
                          result['snippet'] as String? ?? '',
                          searchQuery,
                          AppTheme.lightTheme.textTheme.bodySmall!,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 1.h),

                      // Metadata
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName:
                                _getTypeIcon(result['type'] as String? ?? ''),
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              result['location'] as String? ?? '',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (result['date'] != null) ...[
                            SizedBox(width: 2.w),
                            Text(
                              result['date'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'events':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'people':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'places':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'culture':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'events':
        return 'event';
      case 'people':
        return 'person';
      case 'places':
        return 'place';
      case 'culture':
        return 'palette';
      default:
        return 'article';
    }
  }

  TextSpan _buildHighlightedText(
      String text, String query, TextStyle baseStyle) {
    if (query.isEmpty) {
      return TextSpan(text: text, style: baseStyle);
    }

    final List<TextSpan> spans = [];
    final String lowerText = text.toLowerCase();
    final String lowerQuery = query.toLowerCase();

    int start = 0;
    int index = lowerText.indexOf(lowerQuery);

    while (index != -1) {
      // Add text before match
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: baseStyle,
        ));
      }

      // Add highlighted match
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: baseStyle.copyWith(
          backgroundColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          fontWeight: FontWeight.w600,
        ),
      ));

      start = index + query.length;
      index = lowerText.indexOf(lowerQuery, start);
    }

    // Add remaining text
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: baseStyle,
      ));
    }

    return TextSpan(children: spans);
  }
}
