import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum SiteType { temple, palace, monument, archaeological }

class HistoricalSiteMarker extends StatelessWidget {
  const HistoricalSiteMarker({
    super.key,
    required this.siteType,
    this.isSelected = false,
    this.onTap,
  });

  final SiteType siteType;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? 8.w : 6.w,
        height: isSelected ? 8.w : 6.w,
        decoration: BoxDecoration(
          color: _getMarkerColor(),
          borderRadius: BorderRadius.circular(isSelected ? 4.w : 3.w),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.surface,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.3),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: _getMarkerIcon(),
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: isSelected ? 20 : 16,
          ),
        ),
      ),
    );
  }

  Color _getMarkerColor() {
    switch (siteType) {
      case SiteType.temple:
        return AppTheme.lightTheme.colorScheme.primary;
      case SiteType.palace:
        return AppTheme.lightTheme.colorScheme.secondary;
      case SiteType.monument:
        return AppTheme.lightTheme.colorScheme.tertiary;
      case SiteType.archaeological:
        return AppTheme.warningColor;
    }
  }

  String _getMarkerIcon() {
    switch (siteType) {
      case SiteType.temple:
        return 'temple_hindu';
      case SiteType.palace:
        return 'castle';
      case SiteType.monument:
        return 'account_balance';
      case SiteType.archaeological:
        return 'archaeology';
    }
  }
}
