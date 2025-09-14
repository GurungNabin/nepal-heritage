import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data structure
class NavigationItem {
  const NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
}

/// Adaptive Navigation - Bottom navigation for primary sections
class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8.0,
    this.type = BottomNavigationBarType.fixed,
  });

  /// Current selected index
  final int currentIndex;

  /// Callback when item is tapped
  final ValueChanged<int>? onTap;

  /// Background color override
  final Color? backgroundColor;

  /// Selected item color override
  final Color? selectedItemColor;

  /// Unselected item color override
  final Color? unselectedItemColor;

  /// Elevation of the bottom bar
  final double elevation;

  /// Type of bottom navigation bar
  final BottomNavigationBarType type;

  /// Navigation items for cultural heritage app
  static const List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/home-screen',
    ),
    NavigationItem(
      icon: Icons.timeline_outlined,
      activeIcon: Icons.timeline,
      label: 'Timeline',
      route: '/timeline-screen',
    ),
    NavigationItem(
      icon: Icons.museum_outlined,
      activeIcon: Icons.museum,
      label: 'Highlights',
      route: '/cultural-highlights-screen',
    ),
    NavigationItem(
      icon: Icons.map_outlined,
      activeIcon: Icons.map,
      label: 'Map',
      route: '/interactive-map-screen',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: elevation,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return _buildNavigationItem(
                context,
                theme,
                colorScheme,
                item,
                index,
                isSelected,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    NavigationItem item,
    int index,
    bool isSelected,
  ) {
    final itemColor = isSelected
        ? (selectedItemColor ??
            theme.bottomNavigationBarTheme.selectedItemColor ??
            colorScheme.primary)
        : (unselectedItemColor ??
            theme.bottomNavigationBarTheme.unselectedItemColor ??
            colorScheme.onSurface.withValues(alpha: 0.6));

    return Expanded(
      child: InkWell(
        onTap: () => _handleTap(context, index, item.route),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? itemColor.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  key: ValueKey(isSelected),
                  color: itemColor,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.inter(
                  fontSize: isSelected ? 12 : 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: itemColor,
                  letterSpacing: 0.5,
                ),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, int index, String route) {
    // Call the onTap callback if provided
    onTap?.call(index);

    // Navigate to the selected route if it's different from current
    if (index != currentIndex) {
      // Use pushReplacementNamed to replace the current route
      // This maintains the bottom navigation state
      Navigator.pushReplacementNamed(context, route);
    }
  }
}

/// Helper widget to determine current index based on route
class CustomBottomBarWrapper extends StatelessWidget {
  const CustomBottomBarWrapper({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  final Widget child;
  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(currentRoute);

    return Scaffold(
      body: child,
      bottomNavigationBar: CustomBottomBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // Handle navigation tap
          final route = CustomBottomBar._navigationItems[index].route;
          if (route != currentRoute) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
      ),
    );
  }

  int _getCurrentIndex(String route) {
    for (int i = 0; i < CustomBottomBar._navigationItems.length; i++) {
      if (CustomBottomBar._navigationItems[i].route == route) {
        return i;
      }
    }
    return 0; // Default to home if route not found
  }
}
