import 'package:flutter/material.dart';
import '../presentation/search_results_screen/search_results_screen.dart';
import '../presentation/cultural_highlights_screen/cultural_highlights_screen.dart';
import '../presentation/interactive_map_screen/interactive_map_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/timeline_screen/timeline_screen.dart';
import '../presentation/content_detail_screen/content_detail_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String searchResults = '/search-results-screen';
  static const String culturalHighlights = '/cultural-highlights-screen';
  static const String interactiveMap = '/interactive-map-screen';
  static const String home = '/home-screen';
  static const String timeline = '/timeline-screen';
  static const String contentDetail = '/content-detail-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SearchResultsScreen(),
    searchResults: (context) => const SearchResultsScreen(),
    culturalHighlights: (context) => const CulturalHighlightsScreen(),
    interactiveMap: (context) => const InteractiveMapScreen(),
    home: (context) => const HomeScreen(),
    timeline: (context) => const TimelineScreen(),
    contentDetail: (context) => const ContentDetailScreen(),
    // TODO: Add your other routes here
  };
}
