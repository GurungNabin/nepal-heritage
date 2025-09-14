import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

enum SortOption {
  relevance,
  date,
  popularity,
}

class SortOptionsWidget extends StatelessWidget {
  const SortOptionsWidget({
    super.key,
    required this.selectedSort,
    required this.onSortChanged,
  });

  final SortOption selectedSort;
  final ValueChanged<SortOption> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sort Results',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...SortOption.values.map((option) => RadioListTile<SortOption>(
                title: Text(
                  _getSortOptionLabel(option),
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                subtitle: Text(
                  _getSortOptionDescription(option),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
                value: option,
                groupValue: selectedSort,
                onChanged: (value) {
                  if (value != null) {
                    onSortChanged(value);
                    Navigator.pop(context);
                  }
                },
                activeColor: AppTheme.lightTheme.colorScheme.primary,
                contentPadding: EdgeInsets.zero,
              )),
        ],
      ),
    );
  }

  String _getSortOptionLabel(SortOption option) {
    switch (option) {
      case SortOption.relevance:
        return 'Relevance';
      case SortOption.date:
        return 'Date';
      case SortOption.popularity:
        return 'Popularity';
    }
  }

  String _getSortOptionDescription(SortOption option) {
    switch (option) {
      case SortOption.relevance:
        return 'Best match for your search';
      case SortOption.date:
        return 'Most recent first';
      case SortOption.popularity:
        return 'Most viewed content';
    }
  }
}
