import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum MapLayerType { normal, satellite, terrain }

class MapLayerToggle extends StatelessWidget {
  const MapLayerToggle({
    super.key,
    required this.currentLayer,
    this.onLayerChanged,
  });

  final MapLayerType currentLayer;
  final ValueChanged<MapLayerType>? onLayerChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.h, right: 4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLayerButton(
            context,
            MapLayerType.normal,
            'Normal',
            'layers',
          ),
          SizedBox(height: 1.h),
          _buildLayerButton(
            context,
            MapLayerType.satellite,
            'Satellite',
            'satellite',
          ),
          SizedBox(height: 1.h),
          _buildLayerButton(
            context,
            MapLayerType.terrain,
            'Terrain',
            'terrain',
          ),
        ],
      ),
    );
  }

  Widget _buildLayerButton(
    BuildContext context,
    MapLayerType layerType,
    String label,
    String iconName,
  ) {
    final isSelected = currentLayer == layerType;

    return GestureDetector(
      onTap: () => onLayerChanged?.call(layerType),
      child: Container(
        width: 12.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.onPrimary
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 16,
            ),
            SizedBox(height: 0.2.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontSize: 8.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
