import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.searchQuery,
    required this.onSuggestionTap,
  });

  final String searchQuery;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10.h),

          // Empty state illustration
          Container(
            width: 40.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'search_off',
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.6),
                size: 80,
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // No results message
          Text(
            'No Results Found',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          Text(
            'We couldn\'t find anything for "$searchQuery"',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Search suggestions
          Text(
            'Try searching for:',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.8),
            ),
          ),

          SizedBox(height: 2.h),

          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _getSuggestions()
                .map((suggestion) => ActionChip(
                      label: Text(
                        suggestion,
                        style: AppTheme.lightTheme.textTheme.labelMedium,
                      ),
                      onPressed: () => onSuggestionTap(suggestion),
                      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                      side: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ))
                .toList(),
          ),

          SizedBox(height: 4.h),

          // Popular content section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Popular Content',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                ..._getPopularContent().map((content) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 12.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color:
                              _getContentTypeColor(content['type'] as String),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName:
                                _getContentTypeIcon(content['type'] as String),
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                      title: Text(
                        content['title'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        content['type'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                      onTap: () => onSuggestionTap(content['title'] as String),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getSuggestions() {
    return [
      'Temples',
      'Festivals',
      'Kings',
      'Architecture',
      'Mountains',
      'Art',
      'Music',
      'Food',
    ];
  }

  List<Map<String, String>> _getPopularContent() {
    return [
      {
        'title': 'Kathmandu Durbar Square',
        'type': 'Places',
      },
      {
        'title': 'Prithvi Narayan Shah',
        'type': 'People',
      },
      {
        'title': 'Dashain Festival',
        'type': 'Culture',
      },
      {
        'title': 'Unification of Nepal',
        'type': 'Events',
      },
    ];
  }

  Color _getContentTypeColor(String type) {
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

  String _getContentTypeIcon(String type) {
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
}
