import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TimelineSearchBar extends StatefulWidget {
  final String searchQuery;
  final Function(String) onSearchChanged;
  final VoidCallback onFilterTap;
  final List<String> activeFilters;

  const TimelineSearchBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onFilterTap,
    required this.activeFilters,
  });

  @override
  State<TimelineSearchBar> createState() => _TimelineSearchBarState();
}

class _TimelineSearchBarState extends State<TimelineSearchBar> {
  late TextEditingController _searchController;
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
                child: _buildSearchField(context, theme, colorScheme),
              ),
              SizedBox(width: 3.w),
              _buildFilterButton(context, theme, colorScheme),
            ],
          ),
          if (widget.activeFilters.isNotEmpty) ...[
            SizedBox(height: 1.h),
            _buildActiveFilters(context, theme, colorScheme),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchField(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: _isSearchFocused
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.3),
          width: _isSearchFocused ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: widget.onSearchChanged,
        onTap: () {
          setState(() {
            _isSearchFocused = true;
          });
        },
        onTapOutside: (event) {
          setState(() {
            _isSearchFocused = false;
          });
          FocusScope.of(context).unfocus();
        },
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search historical events...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: _isSearchFocused
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.6),
              size: 20,
            ),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    widget.onSearchChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        ),
      ),
    );
  }

  Widget _buildFilterButton(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    final hasActiveFilters = widget.activeFilters.isNotEmpty;

    return GestureDetector(
      onTap: widget.onFilterTap,
      child: Container(
        width: 6.h,
        height: 6.h,
        decoration: BoxDecoration(
          color: hasActiveFilters ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: hasActiveFilters
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomIconWidget(
              iconName: 'filter_list',
              color: hasActiveFilters
                  ? colorScheme.onPrimary
                  : colorScheme.onSurface.withValues(alpha: 0.7),
              size: 20,
            ),
            if (hasActiveFilters)
              Positioned(
                top: 1.h,
                right: 1.h,
                child: Container(
                  width: 2.w,
                  height: 2.w,
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.activeFilters.length.toString(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onError,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilters(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return SizedBox(
      height: 4.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.activeFilters.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final filter = widget.activeFilters[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  filter,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 1.w),
                GestureDetector(
                  onTap: () {
                    // Remove filter logic would be handled by parent
                  },
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.primary,
                    size: 14,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
