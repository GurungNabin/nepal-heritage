import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class FilterBottomSheetWidget extends StatefulWidget {
  const FilterBottomSheetWidget({
    super.key,
    required this.onApplyFilters,
    this.initialFilters,
  });

  final Function(Map<String, dynamic>) onApplyFilters;
  final Map<String, dynamic>? initialFilters;

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  String _selectedSortBy = 'recent';
  String _selectedTimeRange = 'all';
  List<String> _selectedCategories = [];
  bool _showBookmarkedOnly = false;
  bool _showOfflineOnly = false;

  final List<String> _sortOptions = [
    'recent',
    'popular',
    'alphabetical',
    'oldest',
  ];

  final List<String> _timeRangeOptions = [
    'all',
    'ancient',
    'medieval',
    'modern',
  ];

  final List<String> _categoryOptions = [
    'Art',
    'Music',
    'Food',
    'Literature',
    'Festivals',
    'Crafts',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialFilters != null) {
      _selectedSortBy = widget.initialFilters!['sortBy'] ?? 'recent';
      _selectedTimeRange = widget.initialFilters!['timeRange'] ?? 'all';
      _selectedCategories =
          List<String>.from(widget.initialFilters!['categories'] ?? []);
      _showBookmarkedOnly = widget.initialFilters!['bookmarkedOnly'] ?? false;
      _showOfflineOnly = widget.initialFilters!['offlineOnly'] ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSortSection(context),
                  SizedBox(height: 3.h),
                  _buildTimeRangeSection(context),
                  SizedBox(height: 3.h),
                  _buildCategorySection(context),
                  SizedBox(height: 3.h),
                  _buildToggleSection(context),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Filter & Sort',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _resetFilters,
            child: Text(
              'Reset',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _sortOptions.map((option) {
            final isSelected = _selectedSortBy == option;
            return _buildFilterChip(
              context,
              _getSortLabel(option),
              isSelected,
              () => setState(() => _selectedSortBy = option),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeRangeSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time Period',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _timeRangeOptions.map((option) {
            final isSelected = _selectedTimeRange == option;
            return _buildFilterChip(
              context,
              _getTimeRangeLabel(option),
              isSelected,
              () => setState(() => _selectedTimeRange = option),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _categoryOptions.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return _buildFilterChip(
              context,
              category,
              isSelected,
              () {
                setState(() {
                  if (isSelected) {
                    _selectedCategories.remove(category);
                  } else {
                    _selectedCategories.add(category);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildToggleSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Options',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        SwitchListTile(
          title: Text(
            'Bookmarked Only',
            style: theme.textTheme.bodyMedium,
          ),
          subtitle: Text(
            'Show only bookmarked content',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          value: _showBookmarkedOnly,
          onChanged: (value) => setState(() => _showBookmarkedOnly = value),
          contentPadding: EdgeInsets.zero,
        ),
        SwitchListTile(
          title: Text(
            'Offline Content Only',
            style: theme.textTheme.bodyMedium,
          ),
          subtitle: Text(
            'Show only downloaded content',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          value: _showOfflineOnly,
          onChanged: (value) => setState(() => _showOfflineOnly = value),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: ElevatedButton(
                onPressed: _applyFilters,
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedSortBy = 'recent';
      _selectedTimeRange = 'all';
      _selectedCategories.clear();
      _showBookmarkedOnly = false;
      _showOfflineOnly = false;
    });
  }

  void _applyFilters() {
    final filters = {
      'sortBy': _selectedSortBy,
      'timeRange': _selectedTimeRange,
      'categories': _selectedCategories,
      'bookmarkedOnly': _showBookmarkedOnly,
      'offlineOnly': _showOfflineOnly,
    };

    widget.onApplyFilters(filters);
    Navigator.pop(context);
  }

  String _getSortLabel(String sortBy) {
    switch (sortBy) {
      case 'recent':
        return 'Most Recent';
      case 'popular':
        return 'Most Popular';
      case 'alphabetical':
        return 'A-Z';
      case 'oldest':
        return 'Oldest First';
      default:
        return sortBy;
    }
  }

  String _getTimeRangeLabel(String timeRange) {
    switch (timeRange) {
      case 'all':
        return 'All Periods';
      case 'ancient':
        return 'Ancient (Before 300 CE)';
      case 'medieval':
        return 'Medieval (300-1768 CE)';
      case 'modern':
        return 'Modern (1768-Present)';
      default:
        return timeRange;
    }
  }
}
