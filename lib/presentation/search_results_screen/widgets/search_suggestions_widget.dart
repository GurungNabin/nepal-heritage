import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchSuggestionsWidget extends StatelessWidget {
  const SearchSuggestionsWidget({
    super.key,
    required this.suggestions,
    required this.recentSearches,
    required this.onSuggestionTap,
    required this.onRecentSearchTap,
    required this.onClearHistory,
  });

  final List<String> suggestions;
  final List<String> recentSearches;
  final ValueChanged<String> onSuggestionTap;
  final ValueChanged<String> onRecentSearchTap;
  final VoidCallback onClearHistory;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches section
          if (recentSearches.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Searches',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.8),
                    ),
                  ),
                  TextButton(
                    onPressed: onClearHistory,
                    child: Text(
                      'Clear',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...recentSearches.take(5).map((search) => ListTile(
                  leading: CustomIconWidget(
                    iconName: 'history',
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                    size: 20,
                  ),
                  title: Text(
                    search,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  onTap: () => onRecentSearchTap(search),
                  trailing: IconButton(
                    icon: CustomIconWidget(
                      iconName: 'north_west',
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.4),
                      size: 16,
                    ),
                    onPressed: () => onRecentSearchTap(search),
                  ),
                )),
            Divider(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              height: 1,
            ),
          ],

          // Suggestions section
          if (suggestions.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Text(
                'Suggestions',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.8),
                ),
              ),
            ),
            ...suggestions.map((suggestion) => ListTile(
                  leading: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                    size: 20,
                  ),
                  title: Text(
                    suggestion,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  onTap: () => onSuggestionTap(suggestion),
                  trailing: IconButton(
                    icon: CustomIconWidget(
                      iconName: 'north_west',
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.4),
                      size: 16,
                    ),
                    onPressed: () => onSuggestionTap(suggestion),
                  ),
                )),
          ],

          // Popular searches section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Text(
              'Popular Searches',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.8),
              ),
            ),
          ),

          ..._getPopularSearches().map((search) => ListTile(
                leading: CustomIconWidget(
                  iconName: 'trending_up',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                title: Text(
                  search,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                onTap: () => onSuggestionTap(search),
                trailing: IconButton(
                  icon: CustomIconWidget(
                    iconName: 'north_west',
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.4),
                    size: 16,
                  ),
                  onPressed: () => onSuggestionTap(search),
                ),
              )),
        ],
      ),
    );
  }

  List<String> _getPopularSearches() {
    return [
      'Kathmandu Durbar Square',
      'Mount Everest',
      'Buddha',
      'Prithvi Narayan Shah',
      'Newari Architecture',
      'Dashain Festival',
      'Pashupatinath Temple',
      'Lumbini',
    ];
  }
}
