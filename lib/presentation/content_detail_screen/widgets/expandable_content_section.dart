import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExpandableContentSection extends StatefulWidget {
  const ExpandableContentSection({
    super.key,
    required this.overview,
    required this.historicalContext,
    required this.culturalSignificance,
  });

  final String overview;
  final String historicalContext;
  final String culturalSignificance;

  @override
  State<ExpandableContentSection> createState() =>
      _ExpandableContentSectionState();
}

class _ExpandableContentSectionState extends State<ExpandableContentSection> {
  bool _isOverviewExpanded = true;
  bool _isHistoricalExpanded = false;
  bool _isCulturalExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExpandableSection(
            title: 'Overview',
            content: widget.overview,
            isExpanded: _isOverviewExpanded,
            onTap: () =>
                setState(() => _isOverviewExpanded = !_isOverviewExpanded),
            icon: 'info_outline',
          ),
          SizedBox(height: 2.h),
          _buildExpandableSection(
            title: 'Historical Context',
            content: widget.historicalContext,
            isExpanded: _isHistoricalExpanded,
            onTap: () =>
                setState(() => _isHistoricalExpanded = !_isHistoricalExpanded),
            icon: 'history',
          ),
          SizedBox(height: 2.h),
          _buildExpandableSection(
            title: 'Cultural Significance',
            content: widget.culturalSignificance,
            isExpanded: _isCulturalExpanded,
            onTap: () =>
                setState(() => _isCulturalExpanded = !_isCulturalExpanded),
            icon: 'star_outline',
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required String content,
    required bool isExpanded,
    required VoidCallback onTap,
    required String icon,
  }) {
    return Container(
      width: 100.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: icon,
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      title,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Container(
                    width: 100.w,
                    padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                          height: 1,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          content,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontSize: 12.sp,
                            height: 1.6,
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
