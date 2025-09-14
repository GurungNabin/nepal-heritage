import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapFilterBottomSheet extends StatefulWidget {
  const MapFilterBottomSheet({
    super.key,
    this.onFiltersApplied,
  });

  final ValueChanged<Map<String, dynamic>>? onFiltersApplied;

  @override
  State<MapFilterBottomSheet> createState() => _MapFilterBottomSheetState();
}

class _MapFilterBottomSheetState extends State<MapFilterBottomSheet> {
  final List<String> _selectedPeriods = [];
  final List<String> _selectedTypes = [];
  double _radiusValue = 10.0;

  final List<Map<String, dynamic>> _periods = [
    {"id": "ancient", "name": "Ancient Period", "subtitle": "Before 300 CE"},
    {"id": "medieval", "name": "Medieval Period", "subtitle": "300-1768 CE"},
    {"id": "modern", "name": "Modern Period", "subtitle": "1768-Present"},
  ];

  final List<Map<String, dynamic>> _siteTypes = [
    {"id": "temple", "name": "Temples", "icon": "temple_hindu"},
    {"id": "palace", "name": "Palaces", "icon": "castle"},
    {"id": "monument", "name": "Monuments", "icon": "account_balance"},
    {"id": "archaeological", "name": "Archaeological", "icon": "archaeology"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPeriodFilter(),
                  SizedBox(height: 3.h),
                  _buildTypeFilter(),
                  SizedBox(height: 3.h),
                  _buildRadiusFilter(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: EdgeInsets.only(top: 1.h),
      width: 10.w,
      height: 0.5.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Filter Historical Sites',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: _clearAllFilters,
            child: Text(
              'Clear All',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Historical Period',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ..._periods.map((period) => _buildPeriodItem(period)),
      ],
    );
  }

  Widget _buildPeriodItem(Map<String, dynamic> period) {
    final isSelected = _selectedPeriods.contains(period["id"]);

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedPeriods.remove(period["id"]);
            } else {
              _selectedPeriods.add(period["id"] as String);
            }
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Container(
                width: 5.w,
                height: 5.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                    width: 2,
                  ),
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : Colors.transparent,
                ),
                child: isSelected
                    ? Center(
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 12,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      period["name"] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      period["subtitle"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Site Type',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _siteTypes.map((type) => _buildTypeChip(type)).toList(),
        ),
      ],
    );
  }

  Widget _buildTypeChip(Map<String, dynamic> type) {
    final isSelected = _selectedTypes.contains(type["id"]);

    return FilterChip(
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedTypes.add(type["id"] as String);
          } else {
            _selectedTypes.remove(type["id"]);
          }
        });
      },
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: type["icon"] as String,
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.onPrimary
                : AppTheme.lightTheme.colorScheme.onSurface,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(type["name"] as String),
        ],
      ),
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedColor: AppTheme.lightTheme.colorScheme.primary,
      checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
      labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
        color: isSelected
            ? AppTheme.lightTheme.colorScheme.onPrimary
            : AppTheme.lightTheme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildRadiusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Search Radius',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${_radiusValue.toInt()} km',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Slider(
          value: _radiusValue,
          min: 1.0,
          max: 50.0,
          divisions: 49,
          onChanged: (value) {
            setState(() {
              _radiusValue = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Cancel'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _selectedPeriods.clear();
      _selectedTypes.clear();
      _radiusValue = 10.0;
    });
  }

  void _applyFilters() {
    final filters = {
      'periods': _selectedPeriods,
      'types': _selectedTypes,
      'radius': _radiusValue,
    };

    widget.onFiltersApplied?.call(filters);
    Navigator.pop(context);
  }
}
