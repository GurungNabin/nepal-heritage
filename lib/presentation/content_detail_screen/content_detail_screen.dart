import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/action_buttons_section.dart';
import './widgets/content_header_section.dart';
import './widgets/expandable_content_section.dart';
import './widgets/hero_media_section.dart';
import './widgets/media_gallery_section.dart';
import './widgets/related_content_section.dart';

class ContentDetailScreen extends StatefulWidget {
  const ContentDetailScreen({super.key});

  @override
  State<ContentDetailScreen> createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends State<ContentDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  // Mock data for the content detail
  final Map<String, dynamic> _contentData = {
    "id": 1,
    "title": "Pashupatinath Temple",
    "subtitle": "Sacred Hindu temple complex dedicated to Lord Shiva",
    "category": "Architecture",
    "period": "5th Century CE",
    "heroImage":
        "https://images.unsplash.com/photo-1544735716-392fe2489ffa?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "mediaType": "image",
    "overview":
        "Pashupatinath Temple is one of the most sacred Hindu temples dedicated to Lord Shiva. Located on the banks of the Bagmati River in Kathmandu, this UNESCO World Heritage Site represents the pinnacle of Nepalese temple architecture. The temple complex spans both sides of the river and includes numerous smaller temples, ashrams, and ghats where Hindu cremation ceremonies take place.",
    "historicalContext":
        "The current structure dates back to the 5th century CE, though the site has been sacred for much longer. According to Hindu mythology, Lord Shiva once took the form of an antelope and wandered in the forest on the east bank of the Bagmati River. The temple has been rebuilt several times due to earthquakes, with the most recent major reconstruction following the 2015 earthquake that damaged many heritage structures across Nepal.",
    "culturalSignificance":
        "Pashupatinath serves as the spiritual heart of Nepal's Hindu community and attracts millions of pilgrims annually. The temple is particularly significant during Maha Shivaratri, when hundreds of thousands of devotees gather to worship. The complex also serves as a center for traditional Hindu learning and houses numerous sadhus (holy men) who have dedicated their lives to spiritual practice.",
  };

  final List<Map<String, dynamic>> _mediaGallery = [
    {
      "type": "image",
      "url":
          "https://images.unsplash.com/photo-1544735716-392fe2489ffa?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "caption": "Main temple complex with golden roof"
    },
    {
      "type": "image",
      "url":
          "https://images.unsplash.com/photo-1605640840605-14ac1855827b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "caption": "Bagmati River and cremation ghats"
    },
    {
      "type": "video",
      "url":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "caption": "Evening aarti ceremony"
    },
    {
      "type": "3d_model",
      "url":
          "https://images.unsplash.com/photo-1571115764595-644a1f56a55c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "caption": "3D model of temple architecture"
    },
  ];

  final List<Map<String, dynamic>> _relatedContent = [
    {
      "id": 2,
      "title": "Boudhanath Stupa",
      "category": "Buddhism",
      "period": "6th Century CE",
      "imageUrl":
          "https://images.unsplash.com/photo-1605640840605-14ac1855827b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "readTime": 8
    },
    {
      "id": 3,
      "title": "Swayambhunath Temple",
      "category": "Buddhism",
      "period": "5th Century CE",
      "imageUrl":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "readTime": 6
    },
    {
      "id": 4,
      "title": "Kathmandu Durbar Square",
      "category": "Architecture",
      "period": "12th Century CE",
      "imageUrl":
          "https://images.unsplash.com/photo-1571115764595-644a1f56a55c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "readTime": 12
    },
    {
      "id": 5,
      "title": "Changu Narayan Temple",
      "category": "Hinduism",
      "period": "4th Century CE",
      "imageUrl":
          "https://images.unsplash.com/photo-1544735716-392fe2489ffa?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "readTime": 7
    },
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            HeroMediaSection(
              mediaUrl: _contentData['heroImage'] as String,
              mediaType: _contentData['mediaType'] as String,
              onBookmarkTap: _handleBookmark,
              onShareTap: _handleShare,
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ContentHeaderSection(
                    title: _contentData['title'] as String,
                    subtitle: _contentData['subtitle'] as String,
                    category: _contentData['category'] as String,
                    period: _contentData['period'] as String,
                  ),
                  SizedBox(height: 3.h),
                  ExpandableContentSection(
                    overview: _contentData['overview'] as String,
                    historicalContext:
                        _contentData['historicalContext'] as String,
                    culturalSignificance:
                        _contentData['culturalSignificance'] as String,
                  ),
                  SizedBox(height: 4.h),
                  MediaGallerySection(
                    mediaItems: _mediaGallery,
                  ),
                  SizedBox(height: 4.h),
                  RelatedContentSection(
                    relatedItems: _relatedContent,
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ActionButtonsSection(
        onShareTap: _handleShare,
        onBookmarkTap: _handleBookmark,
        onDownloadTap: _handleDownload,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // Simulate content refresh
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Content updated'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleBookmark() {
    // Handle bookmark functionality
    // This would typically save to local storage or sync with backend
  }

  void _handleShare() {
    // Handle share functionality
    // This would typically open native share dialog
  }

  void _handleDownload() {
    // Handle download functionality
    // This would typically download content for offline access
  }
}
