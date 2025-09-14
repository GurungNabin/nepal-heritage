import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TimelineScrubber extends StatefulWidget {
  final List<Map<String, dynamic>> periods;
  final int currentPeriodIndex;
  final Function(int) onPeriodChanged;
  final double scrollProgress;

  const TimelineScrubber({
    super.key,
    required this.periods,
    required this.currentPeriodIndex,
    required this.onPeriodChanged,
    required this.scrollProgress,
  });

  @override
  State<TimelineScrubber> createState() => _TimelineScrubberState();
}

class _TimelineScrubberState extends State<TimelineScrubber> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Positioned(
      right: 2.w,
      top: 10.h,
      bottom: 15.h,
      child: Container(
        width: 12.w,
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(-2, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildScrubberHeader(context, theme, colorScheme),
            Expanded(
              child: _buildScrubberTrack(context, theme, colorScheme),
            ),
            _buildScrubberFooter(context, theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildScrubberHeader(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: CustomIconWidget(
        iconName: 'timeline',
        color: colorScheme.primary,
        size: 20,
      ),
    );
  }

  Widget _buildScrubberTrack(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _isDragging = true;
        });
        HapticFeedback.lightImpact();
      },
      onPanUpdate: (details) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(details.globalPosition);
        final trackHeight =
            renderBox.size.height - 8.h; // Account for header/footer
        final progress = (localPosition.dy - 4.h) / trackHeight;
        final clampedProgress = progress.clamp(0.0, 1.0);

        final periodIndex =
            (clampedProgress * (widget.periods.length - 1)).round();
        if (periodIndex != widget.currentPeriodIndex) {
          widget.onPeriodChanged(periodIndex);
          HapticFeedback.selectionClick();
        }
      },
      onPanEnd: (details) {
        setState(() {
          _isDragging = false;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        child: Stack(
          children: [
            // Track background
            Container(
              width: 2,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            // Active track
            Positioned(
              top: 0,
              child: Container(
                width: 2,
                height: widget.scrollProgress *
                    (MediaQuery.of(context).size.height * 0.6),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
            // Period markers
            ...widget.periods.asMap().entries.map((entry) {
              final index = entry.key;
              final period = entry.value;
              final position = (index / (widget.periods.length - 1)) *
                  (MediaQuery.of(context).size.height * 0.6);

              return Positioned(
                top: position,
                left: -2,
                child: _buildPeriodMarker(
                  context,
                  theme,
                  colorScheme,
                  period,
                  index == widget.currentPeriodIndex,
                ),
              );
            }).toList(),
            // Current position indicator
            Positioned(
              top: widget.scrollProgress *
                      (MediaQuery.of(context).size.height * 0.6) -
                  1.h,
              left: -1.w,
              child: AnimatedContainer(
                duration: Duration(milliseconds: _isDragging ? 0 : 200),
                width: 4.w,
                height: 2.h,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(2.w),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodMarker(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Map<String, dynamic> period,
    bool isActive,
  ) {
    return GestureDetector(
      onTap: () {
        final index = widget.periods.indexOf(period);
        widget.onPeriodChanged(index);
        HapticFeedback.lightImpact();
      },
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: isActive ? colorScheme.primary : colorScheme.outline,
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.surface,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildScrubberFooter(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        children: [
          Text(
            widget.periods.isNotEmpty
                ? widget.periods[widget.currentPeriodIndex]['startYear']
                    .toString()
                : '',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            widget.periods.isNotEmpty
                ? widget.periods[widget.currentPeriodIndex]['endYear']
                    .toString()
                : '',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
