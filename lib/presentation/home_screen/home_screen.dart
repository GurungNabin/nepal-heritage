import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/featured_content_card.dart';
import './widgets/home_app_bar.dart';
import './widgets/nepal_loading_animation.dart';
import './widgets/quick_explore_grid.dart';
import './widgets/whats_new_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  bool _isDarkMode = false;
  bool _isLoading = false;
  int _currentFeaturedIndex = 0;

  // Mock data for featured content
  final List<Map<String, dynamic>> _featuredContent = [
    {
      "id": 1,
      "title": "Malla Dynasty Era",
      "description":
          "Explore the golden age of Nepal's architectural and cultural renaissance during the Malla period (1201-1769 CE).",
      "period": "1201-1769 CE",
      "image":
          "https://images.unsplash.com/photo-1544735716-392fe2489ffa?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "type": "dynasty"
    },
    {
      "id": 2,
      "title": "Kathmandu Valley Heritage",
      "description":
          "Discover the UNESCO World Heritage sites that showcase Nepal's rich architectural legacy.",
      "period": "Ancient-Present",
      "image":
          "https://images.unsplash.com/photo-1605640840605-14ac1855827b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "type": "heritage"
    },
    {
      "id": 3,
      "title": "Buddhist Monasteries",
      "description":
          "Journey through sacred Buddhist sites and their profound spiritual significance in Nepalese culture.",
      "period": "5th Century CE",
      "image":
          "https://images.unsplash.com/photo-1544967882-6abf0c5d6d9e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "type": "religious"
    },
  ];

  // Mock data for quick explore items
  final List<Map<String, dynamic>> _exploreItems = [
    {
      "id": 1,
      "title": "Recent Dynasties",
      "subtitle": "Shah & Rana Periods",
      "icon": "account_balance",
      "count": 12,
      "image":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "route": "/timeline-screen"
    },
    {
      "id": 2,
      "title": "Cultural Highlights",
      "subtitle": "Art, Music & Dance",
      "icon": "palette",
      "count": 28,
      "image":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "route": "/cultural-highlights-screen"
    },
    {
      "id": 3,
      "title": "Notable Figures",
      "subtitle": "Kings & Leaders",
      "icon": "person",
      "count": 15,
      "image":
          "https://images.unsplash.com/photo-1544967882-6abf0c5d6d9e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "route": "/content-detail-screen"
    },
    {
      "id": 4,
      "title": "Sacred Sites",
      "subtitle": "Temples & Stupas",
      "icon": "temple_buddhist",
      "count": 35,
      "image":
          "https://images.unsplash.com/photo-1605640840605-14ac1855827b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "route": "/interactive-map-screen"
    },
  ];

  // Mock data for what's new content
  final List<Map<String, dynamic>> _whatsNewContent = [
    {
      "id": 1,
      "title": "Newly Discovered Artifacts from Lumbini",
      "timeAgo": "2 days ago",
      "image":
          "https://images.unsplash.com/photo-1544967882-6abf0c5d6d9e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "type": "discovery"
    },
    {
      "id": 2,
      "title": "Traditional Newari Architecture Guide",
      "timeAgo": "5 days ago",
      "image":
          "https://images.unsplash.com/photo-1544735716-392fe2489ffa?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "type": "guide"
    },
    {
      "id": 3,
      "title": "Festival Calendar: Dashain 2024",
      "timeAgo": "1 week ago",
      "image":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "type": "festival"
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _pageController.hasClients) {
        final nextPage = (_currentFeaturedIndex + 1) % _featuredContent.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoSlide();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: HomeAppBar(
        isDarkMode: _isDarkMode,
        onThemeToggle: _toggleTheme,
        onSearchTap: () {
          Navigator.pushNamed(context, '/search-results-screen');
        },
      ),
      body: _isLoading
          ? const NepalLoadingAnimation(
              message: 'Loading Nepal heritage content...',
            )
          : RefreshIndicator(
              onRefresh: _refreshContent,
              color: AppTheme.lightTheme.primaryColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    // Featured Content Section
                    _buildFeaturedSection(),
                    SizedBox(height: 3.h),
                    // Quick Explore Section
                    _buildQuickExploreSection(),
                    SizedBox(height: 3.h),
                    // What's New Section
                    WhatsNewSection(
                      newContent: _whatsNewContent,
                      onContentTap: _handleContentTap,
                    ),
                    SizedBox(height: 10.h), // Bottom padding for navigation
                  ],
                ),
              ),
            ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/search-results-screen');
        },
        backgroundColor: AppTheme.lightTheme.primaryColor,
        child: CustomIconWidget(
          iconName: 'search',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Featured Heritage',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 25.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentFeaturedIndex = index;
              });
            },
            itemCount: _featuredContent.length,
            itemBuilder: (context, index) {
              final content = _featuredContent[index];
              return FeaturedContentCard(
                content: content,
                onTap: () => _handleFeaturedContentTap(content),
                onBookmark: () => _handleBookmark(content),
                onShare: () => _handleShare(content),
              );
            },
          ),
        ),
        SizedBox(height: 2.h),
        // Page Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _featuredContent.length,
            (index) => Container(
              width: _currentFeaturedIndex == index ? 8.w : 2.w,
              height: 1.h,
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              decoration: BoxDecoration(
                color: _currentFeaturedIndex == index
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickExploreSection() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Quick Explore',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        QuickExploreGrid(
          exploreItems: _exploreItems,
          onItemTap: _handleExploreItemTap,
        ),
      ],
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    // Theme toggle would be handled by a theme provider in a real app
  }

  Future<void> _refreshContent() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Content refreshed successfully!'),
          backgroundColor: AppTheme.lightTheme.primaryColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleFeaturedContentTap(Map<String, dynamic> content) {
    Navigator.pushNamed(
      context,
      '/content-detail-screen',
      arguments: content,
    );
  }

  void _handleExploreItemTap(Map<String, dynamic> item) {
    final route = (item["route"] as String?) ?? '/content-detail-screen';
    Navigator.pushNamed(context, route, arguments: item);
  }

  void _handleContentTap(Map<String, dynamic> content) {
    Navigator.pushNamed(
      context,
      '/content-detail-screen',
      arguments: content,
    );
  }

  void _handleBookmark(Map<String, dynamic> content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "${content["title"]}" to bookmarks'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to bookmarks screen
          },
        ),
      ),
    );
  }

  void _handleShare(Map<String, dynamic> content) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(4.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Share "${content["title"]}"',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption('link', 'Copy Link'),
                _buildShareOption('message', 'Message'),
                _buildShareOption('email', 'Email'),
                _buildShareOption('more_horiz', 'More'),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(String iconName, String label) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Shared via $label'),
            backgroundColor: AppTheme.lightTheme.primaryColor,
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(3.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
