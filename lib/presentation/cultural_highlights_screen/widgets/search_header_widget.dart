import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

enum ViewMode { grid, list }

class SearchHeaderWidget extends StatelessWidget {
  const SearchHeaderWidget({
    super.key,
    required this.onSearchChanged,
    required this.onViewModeChanged,
    required this.currentViewMode,
    required this.onFilterTap,
    this.searchController,
  });

  final ValueChanged<String> onSearchChanged;
  final ValueChanged<ViewMode> onViewModeChanged;
  final ViewMode currentViewMode;
  final VoidCallback onFilterTap;
  final TextEditingController? searchController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSearchField(context),
              ),
              SizedBox(width: 3.w),
              _buildViewToggle(context),
              SizedBox(width: 2.w),
              _buildFilterButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search cultural heritage...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              size: 5.w,
            ),
          ),
          suffixIcon: searchController?.text.isNotEmpty == true
              ? IconButton(
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 5.w,
                  ),
                  onPressed: () {
                    searchController?.clear();
                    onSearchChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 1.5.h,
          ),
        ),
      ),
    );
  }

  Widget _buildViewToggle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildViewModeButton(
            context,
            ViewMode.grid,
            'grid_view',
            currentViewMode == ViewMode.grid,
          ),
          Container(
            width: 1,
            height: 4.h,
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
          _buildViewModeButton(
            context,
            ViewMode.list,
            'view_list',
            currentViewMode == ViewMode.list,
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeButton(
    BuildContext context,
    ViewMode mode,
    String iconName,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => onViewModeChanged(mode),
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: iconName,
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.6),
          size: 5.w,
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onFilterTap,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: CustomIconWidget(
          iconName: 'tune',
          color: colorScheme.onSurface.withValues(alpha: 0.6),
          size: 5.w,
        ),
      ),
    );
  }
}
