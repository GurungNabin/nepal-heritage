import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/search_result_card_widget.dart';
import './widgets/search_suggestions_widget.dart';
import './widgets/sort_options_widget.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  Set<String> _selectedFilters = {};
  SortOption _selectedSort = SortOption.relevance;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _showSuggestions = true;

  List<Map<String, dynamic>> _searchResults = [];
  List<String> _recentSearches = [];
  List<String> _suggestions = [];

  // Mock data for search results
  final List<Map<String, dynamic>> _allResults = [
    {
      'id': 1,
      'title': 'Kathmandu Durbar Square',
      'type': 'Places',
      'snippet':
          'Historic palace complex in the heart of Kathmandu, showcasing traditional Nepalese architecture and royal heritage.',
      'thumbnail':
          'https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=400&h=300&fit=crop',
      'location': 'Kathmandu, Nepal',
      'date': '14th Century',
      'relevance': 0.95,
      'popularity': 1200,
      'timestamp': DateTime.now().subtract(const Duration(days: 30)),
    },
    {
      'id': 2,
      'title': 'Prithvi Narayan Shah',
      'type': 'People',
      'snippet':
          'The founder and first king of unified Nepal, who conquered and unified various small kingdoms into one nation.',
      'thumbnail':
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop',
      'location': 'Gorkha, Nepal',
      'date': '1723-1775',
      'relevance': 0.88,
      'popularity': 950,
      'timestamp': DateTime.now().subtract(const Duration(days: 45)),
    },
    {
      'id': 3,
      'title': 'Dashain Festival',
      'type': 'Culture',
      'snippet':
          'The most significant Hindu festival in Nepal, celebrating the victory of good over evil with family gatherings and rituals.',
      'thumbnail':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
      'location': 'Throughout Nepal',
      'date': 'Annual Festival',
      'relevance': 0.82,
      'popularity': 1500,
      'timestamp': DateTime.now().subtract(const Duration(days: 10)),
    },
    {
      'id': 4,
      'title': 'Unification of Nepal',
      'type': 'Events',
      'snippet':
          'The historical process of unifying various small kingdoms and principalities into the modern nation of Nepal.',
      'thumbnail':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop',
      'location': 'Nepal',
      'date': '1743-1816',
      'relevance': 0.79,
      'popularity': 800,
      'timestamp': DateTime.now().subtract(const Duration(days: 60)),
    },
    {
      'id': 5,
      'title': 'Pashupatinath Temple',
      'type': 'Places',
      'snippet':
          'Sacred Hindu temple dedicated to Lord Shiva, located on the banks of the Bagmati River in Kathmandu.',
      'thumbnail':
          'https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=400&h=300&fit=crop',
      'location': 'Kathmandu, Nepal',
      'date': '5th Century',
      'relevance': 0.91,
      'popularity': 1100,
      'timestamp': DateTime.now().subtract(const Duration(days: 20)),
    },
    {
      'id': 6,
      'title': 'Buddha (Siddhartha Gautama)',
      'type': 'People',
      'snippet':
          'The founder of Buddhism, born in Lumbini, Nepal, whose teachings spread throughout Asia and the world.',
      'thumbnail':
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop',
      'location': 'Lumbini, Nepal',
      'date': '563-483 BCE',
      'relevance': 0.94,
      'popularity': 2000,
      'timestamp': DateTime.now().subtract(const Duration(days: 100)),
    },
    {
      'id': 7,
      'title': 'Newari Architecture',
      'type': 'Culture',
      'snippet':
          'Traditional architectural style of the Newar people, characterized by intricate wood carvings and pagoda-style buildings.',
      'thumbnail':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop',
      'location': 'Kathmandu Valley',
      'date': 'Medieval Period',
      'relevance': 0.76,
      'popularity': 650,
      'timestamp': DateTime.now().subtract(const Duration(days: 40)),
    },
    {
      'id': 8,
      'title': 'Mount Everest Discovery',
      'type': 'Events',
      'snippet':
          'The identification and naming of the world\'s highest peak, known locally as Sagarmatha in Nepal.',
      'thumbnail':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop',
      'location': 'Solukhumbu, Nepal',
      'date': '1856',
      'relevance': 0.85,
      'popularity': 1800,
      'timestamp': DateTime.now().subtract(const Duration(days: 15)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadRecentSearches();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreResults();
    }
  }

  void _loadRecentSearches() {
    // Mock recent searches
    _recentSearches = [
      'Kathmandu temples',
      'Nepal kings',
      'Buddhist heritage',
      'Traditional festivals',
    ];
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _showSuggestions = query.isEmpty;
    });

    if (query.isNotEmpty) {
      _generateSuggestions(query);
      _performSearch();
    } else {
      setState(() {
        _searchResults.clear();
        _suggestions.clear();
      });
    }
  }

  void _generateSuggestions(String query) {
    final allTitles =
        _allResults.map((result) => result['title'] as String).toList();
    _suggestions = allTitles
        .where((title) =>
            title.toLowerCase().contains(query.toLowerCase()) &&
            title.toLowerCase() != query.toLowerCase())
        .take(5)
        .toList();
  }

  void _performSearch() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final filteredResults = _filterAndSortResults();
        setState(() {
          _searchResults = filteredResults.take(10).toList();
          _isLoading = false;
          _hasMore = filteredResults.length > 10;
          _showSuggestions = false;
        });

        // Add to recent searches
        if (_searchQuery.isNotEmpty &&
            !_recentSearches.contains(_searchQuery)) {
          setState(() {
            _recentSearches.insert(0, _searchQuery);
            if (_recentSearches.length > 10) {
              _recentSearches.removeLast();
            }
          });
        }
      }
    });
  }

  List<Map<String, dynamic>> _filterAndSortResults() {
    var results = _allResults.where((result) {
      final title = (result['title'] as String).toLowerCase();
      final snippet = (result['snippet'] as String).toLowerCase();
      final type = result['type'] as String;
      final query = _searchQuery.toLowerCase();

      // Filter by search query
      final matchesQuery = title.contains(query) || snippet.contains(query);

      // Filter by selected filters
      final matchesFilter =
          _selectedFilters.isEmpty || _selectedFilters.contains(type);

      return matchesQuery && matchesFilter;
    }).toList();

    // Sort results
    switch (_selectedSort) {
      case SortOption.relevance:
        results.sort((a, b) =>
            (b['relevance'] as double).compareTo(a['relevance'] as double));
        break;
      case SortOption.date:
        results.sort((a, b) =>
            (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));
        break;
      case SortOption.popularity:
        results.sort((a, b) =>
            (b['popularity'] as int).compareTo(a['popularity'] as int));
        break;
    }

    return results;
  }

  void _loadMoreResults() {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final filteredResults = _filterAndSortResults();
        final currentLength = _searchResults.length;
        final newResults =
            filteredResults.skip(currentLength).take(10).toList();

        setState(() {
          _searchResults.addAll(newResults);
          _isLoading = false;
          _hasMore = filteredResults.length > _searchResults.length;
        });
      }
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter);
      } else {
        _selectedFilters.add(filter);
      }
    });

    if (_searchQuery.isNotEmpty) {
      _performSearch();
    }
  }

  void _onSortChanged(SortOption sort) {
    setState(() {
      _selectedSort = sort;
    });

    if (_searchQuery.isNotEmpty) {
      _performSearch();
    }
  }

  Map<String, int> _getFilterCounts() {
    final counts = <String, int>{};

    for (final result in _allResults) {
      final type = result['type'] as String;
      final title = (result['title'] as String).toLowerCase();
      final snippet = (result['snippet'] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();

      if (query.isEmpty || title.contains(query) || snippet.contains(query)) {
        counts[type] = (counts[type] ?? 0) + 1;
      }
    }

    return counts;
  }

  void _onVoiceSearch() {
    Fluttertoast.showToast(
      msg: "Voice search feature coming soon",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onSuggestionTap(String suggestion) {
    setState(() {
      _searchQuery = suggestion;
      _showSuggestions = false;
    });
    _performSearch();
  }

  void _onRecentSearchTap(String search) {
    setState(() {
      _searchQuery = search;
      _showSuggestions = false;
    });
    _performSearch();
  }

  void _onClearHistory() {
    setState(() {
      _recentSearches.clear();
    });
    Fluttertoast.showToast(
      msg: "Search history cleared",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onResultTap(Map<String, dynamic> result) {
    Navigator.pushNamed(
      context,
      '/content-detail-screen',
      arguments: result,
    );
  }

  void _onBookmark(Map<String, dynamic> result) {
    Fluttertoast.showToast(
      msg: "Added to bookmarks: ${result['title']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onShare(Map<String, dynamic> result) {
    Fluttertoast.showToast(
      msg: "Sharing: ${result['title']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onViewSimilar(Map<String, dynamic> result) {
    final type = result['type'] as String;
    setState(() {
      _selectedFilters = {type};
      _searchQuery = '';
    });
    _performSearch();

    Fluttertoast.showToast(
      msg: "Showing similar $type content",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SortOptionsWidget(
        selectedSort: _selectedSort,
        onSortChanged: _onSortChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            SearchBarWidget(
              onSearchChanged: _onSearchChanged,
              onVoiceSearch: _onVoiceSearch,
              onCancel: _onCancel,
              initialQuery: _searchQuery,
            ),

            // Filter chips (shown when not showing suggestions)
            if (!_showSuggestions) ...[
              FilterChipsWidget(
                selectedFilters: _selectedFilters,
                onFilterChanged: _onFilterChanged,
                filterCounts: _getFilterCounts(),
              ),

              // Results header with sort option
              if (_searchResults.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_searchResults.length} results for "$_searchQuery"',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _showSortOptions,
                        icon: CustomIconWidget(
                          iconName: 'sort',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                        label: Text(
                          'Sort',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],

            // Main content area
            Expanded(
              child: _showSuggestions
                  ? SearchSuggestionsWidget(
                      suggestions: _suggestions,
                      recentSearches: _recentSearches,
                      onSuggestionTap: _onSuggestionTap,
                      onRecentSearchTap: _onRecentSearchTap,
                      onClearHistory: _onClearHistory,
                    )
                  : _searchResults.isEmpty && !_isLoading
                      ? EmptyStateWidget(
                          searchQuery: _searchQuery,
                          onSuggestionTap: _onSuggestionTap,
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _searchResults.length + (_hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _searchResults.length) {
                              // Loading indicator
                              return Container(
                                padding: EdgeInsets.all(4.w),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                              );
                            }

                            final result = _searchResults[index];
                            return SearchResultCardWidget(
                              result: result,
                              searchQuery: _searchQuery,
                              onTap: () => _onResultTap(result),
                              onBookmark: () => _onBookmark(result),
                              onShare: () => _onShare(result),
                              onViewSimilar: () => _onViewSimilar(result),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
