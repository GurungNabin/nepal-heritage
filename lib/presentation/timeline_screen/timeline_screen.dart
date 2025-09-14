import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/timeline_event_card.dart';
import './widgets/timeline_filter_sheet.dart';
import './widgets/timeline_scrubber.dart';
import './widgets/timeline_search_bar.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;

  String _searchQuery = '';
  Map<String, List<String>> _selectedFilters = {};
  List<Map<String, dynamic>> _filteredEvents = [];
  double _scrollProgress = 0.0;
  int _currentPeriodIndex = 0;
  bool _isLoading = false;
  DateTime? _lastUpdated;

  // Mock data for timeline events
  final List<Map<String, dynamic>> _timelineEvents = [
    {
      "id": 1,
      "title": "Foundation of Kathmandu",
      "description":
          "King Gunakamadeva establishes the city of Kathmandu, originally called Kantipur, marking the beginning of organized settlement in the valley.",
      "date": "723 CE",
      "year": 723,
      "dynasty": "Licchavi Dynasty",
      "type": "Political",
      "region": "Kathmandu Valley",
      "imageUrl":
          "https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=500&h=300&fit=crop",
    },
    {
      "id": 2,
      "title": "Construction of Pashupatinath Temple",
      "description":
          "The sacred Hindu temple dedicated to Lord Shiva is constructed, becoming one of the most important pilgrimage sites in Nepal.",
      "date": "400 CE",
      "year": 400,
      "dynasty": "Licchavi Dynasty",
      "type": "Religious",
      "region": "Kathmandu Valley",
      "imageUrl":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=500&h=300&fit=crop",
    },
    {
      "id": 3,
      "title": "Malla Period Golden Age",
      "description":
          "The Malla kingdoms flourish, bringing unprecedented cultural and artistic development to Nepal with magnificent palaces and temples.",
      "date": "1200-1769 CE",
      "year": 1200,
      "dynasty": "Malla Dynasty",
      "type": "Cultural",
      "region": "Kathmandu Valley",
      "imageUrl":
          "https://images.unsplash.com/photo-1605640840605-14ac1855827b?w=500&h=300&fit=crop",
    },
    {
      "id": 4,
      "title": "Unification of Nepal",
      "description":
          "Prithvi Narayan Shah conquers the Kathmandu Valley and unifies various kingdoms to form modern Nepal.",
      "date": "1768 CE",
      "year": 1768,
      "dynasty": "Shah Dynasty",
      "type": "Political",
      "region": "Central Nepal",
      "imageUrl":
          "https://images.unsplash.com/photo-1571115764595-644a1f56a55c?w=500&h=300&fit=crop",
    },
    {
      "id": 5,
      "title": "Construction of Durbar Squares",
      "description":
          "The magnificent palace complexes in Kathmandu, Patan, and Bhaktapur are built, showcasing Newar architecture and craftsmanship.",
      "date": "1400-1600 CE",
      "year": 1400,
      "dynasty": "Malla Dynasty",
      "type": "Architectural",
      "region": "Kathmandu Valley",
      "imageUrl":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=500&h=300&fit=crop",
    },
    {
      "id": 6,
      "title": "Rana Regime Begins",
      "description":
          "Jung Bahadur Rana establishes the Rana oligarchy, ruling Nepal for over a century while keeping the Shah kings as figureheads.",
      "date": "1846 CE",
      "year": 1846,
      "dynasty": "Rana Dynasty",
      "type": "Political",
      "region": "Central Nepal",
      "imageUrl":
          "https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=500&h=300&fit=crop",
    },
    {
      "id": 7,
      "title": "Democracy Movement",
      "description":
          "The people's movement successfully ends the Rana regime and restores democratic governance under King Tribhuvan.",
      "date": "1950 CE",
      "year": 1950,
      "dynasty": "Shah Dynasty",
      "type": "Political",
      "region": "Central Nepal",
      "imageUrl":
          "https://images.unsplash.com/photo-1571115764595-644a1f56a55c?w=500&h=300&fit=crop",
    },
    {
      "id": 8,
      "title": "Federal Republic Established",
      "description":
          "Nepal becomes a federal democratic republic, ending centuries of monarchical rule and establishing a new constitution.",
      "date": "2008 CE",
      "year": 2008,
      "dynasty": "Modern Nepal",
      "type": "Political",
      "region": "Central Nepal",
      "imageUrl":
          "https://images.unsplash.com/photo-1605640840605-14ac1855827b?w=500&h=300&fit=crop",
    },
  ];

  // Historical periods for scrubber
  final List<Map<String, dynamic>> _historicalPeriods = [
    {"name": "Ancient Period", "startYear": 300, "endYear": 879},
    {"name": "Thakuri Period", "startYear": 879, "endYear": 1200},
    {"name": "Malla Period", "startYear": 1200, "endYear": 1768},
    {"name": "Shah Period", "startYear": 1768, "endYear": 1846},
    {"name": "Rana Period", "startYear": 1846, "endYear": 1950},
    {"name": "Modern Period", "startYear": 1950, "endYear": 2024},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _zoomController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeInOut),
    );

    _filteredEvents = List.from(_timelineEvents);
    _lastUpdated = DateTime.now();

    _scrollController.addListener(_onScroll);
    _loadTimelineData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _zoomController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      setState(() {
        _scrollProgress =
            maxScroll > 0 ? (currentScroll / maxScroll).clamp(0.0, 1.0) : 0.0;
      });

      // Update current period based on scroll position
      final periodIndex =
          (_scrollProgress * (_historicalPeriods.length - 1)).round();
      if (periodIndex != _currentPeriodIndex) {
        setState(() {
          _currentPeriodIndex = periodIndex;
        });
      }
    }
  }

  Future<void> _loadTimelineData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isLoading = false;
      _lastUpdated = DateTime.now();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterEvents();
    });
  }

  void _onFiltersChanged(Map<String, List<String>> filters) {
    setState(() {
      _selectedFilters = filters;
      _filterEvents();
    });
  }

  void _filterEvents() {
    List<Map<String, dynamic>> filtered = List.from(_timelineEvents);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((event) {
        return (event['title'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (event['description'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (event['dynasty'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply category filters
    _selectedFilters.forEach((category, values) {
      if (values.isNotEmpty) {
        filtered = filtered.where((event) {
          switch (category) {
            case 'Dynasties':
              return values.contains(event['dynasty']);
            case 'Event Types':
              return values.contains(event['type']);
            case 'Regions':
              return values.contains(event['region']);
            default:
              return true;
          }
        }).toList();
      }
    });

    // Sort by year
    filtered.sort((a, b) => (a['year'] as int).compareTo(b['year'] as int));

    setState(() {
      _filteredEvents = filtered;
    });
  }

  void _onPeriodChanged(int periodIndex) {
    setState(() {
      _currentPeriodIndex = periodIndex;
    });

    // Scroll to events in this period
    final period = _historicalPeriods[periodIndex];
    final startYear = period['startYear'] as int;
    final endYear = period['endYear'] as int;

    final periodEvents = _filteredEvents.where((event) {
      final year = event['year'] as int;
      return year >= startYear && year <= endYear;
    }).toList();

    if (periodEvents.isNotEmpty) {
      final firstEventIndex = _filteredEvents.indexOf(periodEvents.first);
      final scrollPosition = firstEventIndex * 300.0; // Approximate card height

      _scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onEventTap(Map<String, dynamic> event) {
    Navigator.pushNamed(
      context,
      '/content-detail-screen',
      arguments: event,
    );
  }

  void _onBookmark(Map<String, dynamic> event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${event['title']} bookmarked'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Navigate to bookmarks
          },
        ),
      ),
    );
  }

  void _onShare(Map<String, dynamic> event) {
    // Share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${event['title']}'),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TimelineFilterSheet(
        selectedFilters: _selectedFilters,
        onFiltersChanged: _onFiltersChanged,
      ),
    );
  }

  List<String> _getActiveFiltersList() {
    List<String> activeFilters = [];
    _selectedFilters.forEach((category, values) {
      activeFilters.addAll(values);
    });
    return activeFilters;
  }

  void _handleDoubleTap() {
    if (_zoomController.isCompleted) {
      _zoomController.reverse();
    } else {
      _zoomController.forward();
    }
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                TimelineSearchBar(
                  searchQuery: _searchQuery,
                  onSearchChanged: _onSearchChanged,
                  onFilterTap: _showFilterSheet,
                  activeFilters: _getActiveFiltersList(),
                ),
                Expanded(
                  child: _buildTimelineContent(context, theme, colorScheme),
                ),
              ],
            ),
            TimelineScrubber(
              periods: _historicalPeriods,
              currentPeriodIndex: _currentPeriodIndex,
              onPeriodChanged: _onPeriodChanged,
              scrollProgress: _scrollProgress,
            ),
            if (_isLoading)
              Container(
                color: colorScheme.surface.withValues(alpha: 0.8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Loading Timeline...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
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

  Widget _buildTimelineContent(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    if (_filteredEvents.isEmpty && !_isLoading) {
      return _buildEmptyState(context, theme, colorScheme);
    }

    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: AnimatedBuilder(
        animation: _zoomAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _zoomAnimation.value,
            child: RefreshIndicator(
              onRefresh: _loadTimelineData,
              color: colorScheme.primary,
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 2.h),
                itemCount:
                    _filteredEvents.length + 1, // +1 for last updated info
                itemBuilder: (context, index) {
                  if (index == _filteredEvents.length) {
                    return _buildLastUpdatedInfo(context, theme, colorScheme);
                  }

                  final event = _filteredEvents[index];
                  final isLeft = index % 2 == 0;

                  return TimelineEventCard(
                    event: event,
                    isLeft: isLeft,
                    onTap: () => _onEventTap(event),
                    onBookmark: () => _onBookmark(event),
                    onShare: () => _onShare(event),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'timeline',
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Events Found',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search or filters'
                : 'Timeline events will appear here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _selectedFilters.clear();
                _filterEvents();
              });
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdatedInfo(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'update',
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            'Last updated: ${_lastUpdated != null ? "${_lastUpdated!.day}/${_lastUpdated!.month}/${_lastUpdated!.year}" : "Never"}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
