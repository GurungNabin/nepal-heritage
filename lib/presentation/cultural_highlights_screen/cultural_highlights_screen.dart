import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/category_chip_widget.dart';
import './widgets/content_card_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/search_header_widget.dart';

class CulturalHighlightsScreen extends StatefulWidget {
  const CulturalHighlightsScreen({super.key});

  @override
  State<CulturalHighlightsScreen> createState() =>
      _CulturalHighlightsScreenState();
}

class _CulturalHighlightsScreenState extends State<CulturalHighlightsScreen>
    with TickerProviderStateMixin {
  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  ViewMode _currentViewMode = ViewMode.grid;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  Map<String, dynamic> _currentFilters = {};
  List<String> _selectedItems = [];
  bool _isMultiSelectMode = false;
  bool _isLoading = false;
  bool _isRefreshing = false;

  final List<String> _categories = [
    'All',
    'Art',
    'Music',
    'Food',
    'Literature',
    'Festivals',
    'Crafts',
  ];

  // Mock cultural content data
  final List<Map<String, dynamic>> _culturalContent = [
    {
      "id": "1",
      "title": "Traditional Thangka Painting",
      "description":
          "Ancient Buddhist art form featuring intricate spiritual imagery and vibrant colors, representing Nepal's rich religious heritage.",
      "category": "Art",
      "type": "image",
      "thumbnail":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop",
      "views": 2847,
      "likes": 156,
      "isBookmarked": true,
      "isOffline": true,
      "period": "ancient",
      "createdAt": "2025-09-10T10:30:00Z",
    },
    {
      "id": "2",
      "title": "Newari Classical Music",
      "description":
          "Traditional musical compositions from the Kathmandu Valley, showcasing the sophisticated cultural heritage of the Newar community.",
      "category": "Music",
      "type": "audio",
      "thumbnail":
          "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop",
      "views": 1923,
      "likes": 89,
      "isBookmarked": false,
      "isOffline": false,
      "period": "medieval",
      "createdAt": "2025-09-09T14:15:00Z",
    },
    {
      "id": "3",
      "title": "Dal Bhat Preparation",
      "description":
          "Step-by-step guide to preparing Nepal's national dish, featuring lentil soup, rice, and traditional accompaniments.",
      "category": "Food",
      "type": "video",
      "thumbnail":
          "https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400&h=300&fit=crop",
      "views": 4521,
      "likes": 287,
      "isBookmarked": true,
      "isOffline": true,
      "period": "modern",
      "createdAt": "2025-09-08T09:45:00Z",
    },
    {
      "id": "4",
      "title": "Malla Dynasty Architecture",
      "description":
          "Explore the architectural marvels of the Malla period, including intricate wood carvings and pagoda-style temples.",
      "category": "Art",
      "type": "3d_model",
      "thumbnail":
          "https://images.unsplash.com/photo-1539650116574-75c0c6d73f6e?w=400&h=300&fit=crop",
      "views": 3156,
      "likes": 198,
      "isBookmarked": false,
      "isOffline": false,
      "period": "medieval",
      "createdAt": "2025-09-07T16:20:00Z",
    },
    {
      "id": "5",
      "title": "Dashain Festival Celebrations",
      "description":
          "Experience Nepal's most important festival through traditional rituals, family gatherings, and cultural performances.",
      "category": "Festivals",
      "type": "video",
      "thumbnail":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop",
      "views": 6789,
      "likes": 423,
      "isBookmarked": true,
      "isOffline": false,
      "period": "modern",
      "createdAt": "2025-09-06T11:30:00Z",
    },
    {
      "id": "6",
      "title": "Himalayan Folk Literature",
      "description":
          "Collection of traditional stories and poems from the mountain communities, preserving oral traditions for future generations.",
      "category": "Literature",
      "type": "image",
      "thumbnail":
          "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop",
      "views": 1567,
      "likes": 92,
      "isBookmarked": false,
      "isOffline": true,
      "period": "ancient",
      "createdAt": "2025-09-05T13:45:00Z",
    },
    {
      "id": "7",
      "title": "Traditional Pottery Making",
      "description":
          "Ancient craft techniques passed down through generations, showcasing the skill and artistry of Nepali potters.",
      "category": "Crafts",
      "type": "video",
      "thumbnail":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop",
      "views": 2341,
      "likes": 134,
      "isBookmarked": false,
      "isOffline": false,
      "period": "ancient",
      "createdAt": "2025-09-04T08:15:00Z",
    },
    {
      "id": "8",
      "title": "Tihar Light Festival",
      "description":
          "Festival of lights celebrating the bond between humans and animals, featuring beautiful decorations and traditional sweets.",
      "category": "Festivals",
      "type": "image",
      "thumbnail":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop",
      "views": 5234,
      "likes": 312,
      "isBookmarked": true,
      "isOffline": true,
      "period": "modern",
      "createdAt": "2025-09-03T19:30:00Z",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeInOut,
    ));
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreContent();
      }
    });
  }

  Future<void> _loadMoreContent() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    // Simulate loading more content
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);
  }

  Future<void> _refreshContent() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);
    _refreshController.forward();

    // Simulate refresh with traditional Nepal loading animation
    await Future.delayed(const Duration(seconds: 2));

    _refreshController.reverse();
    setState(() => _isRefreshing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cultural content updated'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  List<Map<String, dynamic>> _getFilteredContent() {
    List<Map<String, dynamic>> filtered = List.from(_culturalContent);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((content) {
        final title = (content['title'] as String).toLowerCase();
        final description = (content['description'] as String).toLowerCase();
        final category = (content['category'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();

        return title.contains(query) ||
            description.contains(query) ||
            category.contains(query);
      }).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((content) => content['category'] == _selectedCategory)
          .toList();
    }

    // Apply additional filters
    if (_currentFilters.isNotEmpty) {
      // Time range filter
      if (_currentFilters['timeRange'] != null &&
          _currentFilters['timeRange'] != 'all') {
        filtered = filtered
            .where(
                (content) => content['period'] == _currentFilters['timeRange'])
            .toList();
      }

      // Category filters
      if (_currentFilters['categories'] != null &&
          (_currentFilters['categories'] as List).isNotEmpty) {
        filtered = filtered
            .where((content) => (_currentFilters['categories'] as List)
                .contains(content['category']))
            .toList();
      }

      // Bookmarked only filter
      if (_currentFilters['bookmarkedOnly'] == true) {
        filtered = filtered
            .where((content) => content['isBookmarked'] == true)
            .toList();
      }

      // Offline only filter
      if (_currentFilters['offlineOnly'] == true) {
        filtered =
            filtered.where((content) => content['isOffline'] == true).toList();
      }

      // Sort filter
      final sortBy = _currentFilters['sortBy'] ?? 'recent';
      switch (sortBy) {
        case 'popular':
          filtered
              .sort((a, b) => (b['views'] as int).compareTo(a['views'] as int));
          break;
        case 'alphabetical':
          filtered.sort(
              (a, b) => (a['title'] as String).compareTo(b['title'] as String));
          break;
        case 'oldest':
          filtered.sort((a, b) =>
              (a['createdAt'] as String).compareTo(b['createdAt'] as String));
          break;
        case 'recent':
        default:
          filtered.sort((a, b) =>
              (b['createdAt'] as String).compareTo(a['createdAt'] as String));
          break;
      }
    }

    return filtered;
  }

  void _handleSearch(String query) {
    setState(() => _searchQuery = query);
  }

  void _handleCategorySelection(String category) {
    setState(() => _selectedCategory = category);
  }

  void _handleViewModeChange(ViewMode mode) {
    setState(() => _currentViewMode = mode);
    HapticFeedback.lightImpact();
  }

  void _handleFilterTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => FilterBottomSheetWidget(
          initialFilters: _currentFilters,
          onApplyFilters: (filters) {
            setState(() => _currentFilters = filters);
          },
        ),
      ),
    );
  }

  void _handleContentTap(Map<String, dynamic> content) {
    if (_isMultiSelectMode) {
      _toggleSelection(content['id'] as String);
    } else {
      Navigator.pushNamed(
        context,
        '/content-detail-screen',
        arguments: content,
      );
    }
  }

  void _handleBookmark(Map<String, dynamic> content) {
    setState(() {
      content['isBookmarked'] = !(content['isBookmarked'] as bool);
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content['isBookmarked']
              ? 'Added to bookmarks'
              : 'Removed from bookmarks',
        ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Navigate to bookmarks
          },
        ),
      ),
    );
  }

  void _handleShare(Map<String, dynamic> content) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share "${content['title']}"',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption('link', 'Copy Link', () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link copied to clipboard')),
                  );
                }),
                _buildShareOption('message', 'Message', () {
                  Navigator.pop(context);
                }),
                _buildShareOption('email', 'Email', () {
                  Navigator.pop(context);
                }),
                _buildShareOption('more_horiz', 'More', () {
                  Navigator.pop(context);
                }),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(String iconName, String label, VoidCallback onTap) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: colorScheme.primary,
              size: 6.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  void _toggleSelection(String contentId) {
    setState(() {
      if (_selectedItems.contains(contentId)) {
        _selectedItems.remove(contentId);
        if (_selectedItems.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedItems.add(contentId);
      }
    });
  }

  void _activateMultiSelectMode(String contentId) {
    setState(() {
      _isMultiSelectMode = true;
      _selectedItems = [contentId];
    });
    HapticFeedback.mediumImpact();
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filteredContent = _getFilteredContent();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _isMultiSelectMode
          ? _buildMultiSelectAppBar()
          : _buildStandardAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshContent,
        color: colorScheme.primary,
        child: Column(
          children: [
            SearchHeaderWidget(
              searchController: _searchController,
              onSearchChanged: _handleSearch,
              onViewModeChanged: _handleViewModeChange,
              currentViewMode: _currentViewMode,
              onFilterTap: _handleFilterTap,
            ),
            _buildCategoryChips(),
            Expanded(
              child: _isRefreshing
                  ? _buildLoadingAnimation()
                  : _buildContentGrid(filteredContent),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          _isMultiSelectMode ? null : const CustomBottomBar(currentIndex: 2),
      floatingActionButton: _isMultiSelectMode
          ? null
          : FloatingActionButton(
              onPressed: _handleFilterTap,
              child: CustomIconWidget(
                iconName: 'tune',
                color: colorScheme.onPrimary,
                size: 6.w,
              ),
            ),
    );
  }

  PreferredSizeWidget _buildStandardAppBar() {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        'Cultural Highlights',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'search',
            color: theme.appBarTheme.foregroundColor!,
            size: 6.w,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/search-results-screen');
          },
        ),
      ],
    );
  }

  PreferredSizeWidget _buildMultiSelectAppBar() {
    final theme = Theme.of(context);

    return AppBar(
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'close',
          color: theme.appBarTheme.foregroundColor!,
          size: 6.w,
        ),
        onPressed: _exitMultiSelectMode,
      ),
      title: Text(
        '${_selectedItems.length} selected',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'bookmark',
            color: theme.appBarTheme.foregroundColor!,
            size: 6.w,
          ),
          onPressed: () {
            // Batch bookmark
            _exitMultiSelectMode();
          },
        ),
        IconButton(
          icon: CustomIconWidget(
            iconName: 'share',
            color: theme.appBarTheme.foregroundColor!,
            size: 6.w,
          ),
          onPressed: () {
            // Batch share
            _exitMultiSelectMode();
          },
        ),
        IconButton(
          icon: CustomIconWidget(
            iconName: 'download',
            color: theme.appBarTheme.foregroundColor!,
            size: 6.w,
          ),
          onPressed: () {
            // Batch download
            _exitMultiSelectMode();
          },
        ),
      ],
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return CategoryChipWidget(
            label: category,
            isSelected: _selectedCategory == category,
            onTap: () => _handleCategorySelection(category),
          );
        },
      ),
    );
  }

  Widget _buildContentGrid(List<Map<String, dynamic>> content) {
    if (content.isEmpty) {
      return _buildEmptyState();
    }

    return _currentViewMode == ViewMode.grid
        ? _buildMasonryGrid(content)
        : _buildListView(content);
  }

  Widget _buildMasonryGrid(List<Map<String, dynamic>> content) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(4.w),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= content.length) {
                  return _buildLoadingCard();
                }

                final item = content[index];
                return ContentCardWidget(
                  content: item,
                  isSelected: _selectedItems.contains(item['id']),
                  onTap: () => _handleContentTap(item),
                  onBookmark: () => _handleBookmark(item),
                  onShare: () => _handleShare(item),
                );
              },
              childCount: content.length + (_isLoading ? 2 : 0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> content) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(4.w),
      itemCount: content.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= content.length) {
          return _buildLoadingCard();
        }

        final item = content[index];
        return ContentCardWidget(
          content: item,
          isSelected: _selectedItems.contains(item['id']),
          onTap: () => _handleContentTap(item),
          onBookmark: () => _handleBookmark(item),
          onShare: () => _handleShare(item),
        );
      },
    );
  }

  Widget _buildLoadingCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            height: 20.h,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 2.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  height: 1.5.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: AnimatedBuilder(
        animation: _refreshAnimation,
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.rotate(
                angle: _refreshAnimation.value * 2 * 3.14159,
                child: Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'temple_buddhist',
                    color: colorScheme.primary,
                    size: 8.w,
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Discovering Cultural Heritage...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: CustomIconWidget(
              iconName: 'explore',
              color: colorScheme.primary,
              size: 15.w,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Discover Culture',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'No cultural content found.\nTry adjusting your search or filters.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _selectedCategory = 'All';
                _currentFilters.clear();
                _searchController.clear();
              });
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }
}
