import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/map_filter_bottom_sheet.dart';
import './widgets/map_layer_toggle.dart';
import './widgets/map_search_bar.dart';
import './widgets/nearby_sites_bottom_sheet.dart';
import './widgets/site_preview_card.dart';

class InteractiveMapScreen extends StatefulWidget {
  const InteractiveMapScreen({super.key});

  @override
  State<InteractiveMapScreen> createState() => _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends State<InteractiveMapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  MapLayerType _currentLayer = MapLayerType.normal;
  Map<String, dynamic>? _selectedSite;
  bool _showPreviewCard = false;
  final Set<Marker> _markers = {};
  bool _isLoading = true;
  String _searchQuery = '';
  Map<String, dynamic> _appliedFilters = {};

  // Mock data for historical sites
  final List<Map<String, dynamic>> _historicalSites = [
    {
      "id": "1",
      "name": "Pashupatinath Temple",
      "location": "Kathmandu, Nepal",
      "latitude": 27.7106,
      "longitude": 85.3487,
      "type": "temple",
      "period": "Ancient",
      "distance": 2.5,
      "image":
          "https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=500&h=300&fit=crop",
      "description":
          "A sacred Hindu temple complex located on the banks of the Bagmati River, dedicated to Lord Shiva. This UNESCO World Heritage Site is one of the most significant temples in Nepal.",
    },
    {
      "id": "2",
      "name": "Kathmandu Durbar Square",
      "location": "Kathmandu, Nepal",
      "latitude": 27.7040,
      "longitude": 85.3070,
      "type": "palace",
      "period": "Medieval",
      "distance": 1.8,
      "image":
          "https://images.unsplash.com/photo-1605640840605-14ac1855827b?w=500&h=300&fit=crop",
      "description":
          "The royal palace of the former Kathmandu Kingdom, showcasing traditional Nepalese architecture and housing several temples, courtyards, and museums.",
    },
    {
      "id": "3",
      "name": "Swayambhunath Stupa",
      "location": "Kathmandu, Nepal",
      "latitude": 27.7149,
      "longitude": 85.2906,
      "type": "monument",
      "period": "Ancient",
      "distance": 3.2,
      "image":
          "https://images.unsplash.com/photo-1605640840605-14ac1855827b?w=500&h=300&fit=crop",
      "description":
          "Also known as the Monkey Temple, this ancient religious architecture atop a hill in the Kathmandu Valley offers panoramic views of the city.",
    },
    {
      "id": "4",
      "name": "Boudhanath Stupa",
      "location": "Kathmandu, Nepal",
      "latitude": 27.7215,
      "longitude": 85.3620,
      "type": "monument",
      "period": "Ancient",
      "distance": 4.1,
      "image":
          "https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=500&h=300&fit=crop",
      "description":
          "One of the largest spherical stupas in Nepal and the world, this UNESCO World Heritage Site is a center of Tibetan Buddhism in Kathmandu.",
    },
    {
      "id": "5",
      "name": "Patan Durbar Square",
      "location": "Lalitpur, Nepal",
      "latitude": 27.6722,
      "longitude": 85.3256,
      "type": "palace",
      "period": "Medieval",
      "distance": 5.7,
      "image":
          "https://images.unsplash.com/photo-1605640840605-14ac1855827b?w=500&h=300&fit=crop",
      "description":
          "A stunning display of Newari architecture with its ancient palace, temples, and courtyards, showcasing the rich cultural heritage of the Malla period.",
    },
    {
      "id": "6",
      "name": "Changu Narayan Temple",
      "location": "Bhaktapur, Nepal",
      "latitude": 27.7167,
      "longitude": 85.4333,
      "type": "temple",
      "period": "Ancient",
      "distance": 8.9,
      "image":
          "https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=500&h=300&fit=crop",
      "description":
          "The oldest Hindu temple in the Kathmandu Valley, dedicated to Lord Vishnu, featuring exquisite stone and wood carvings dating back to the 4th century.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    try {
      await _getCurrentLocation();
      _createMarkers();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Unable to load map. Please check your location settings.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      // Default to Kathmandu center if location fails
      _currentPosition = Position(
        latitude: 27.7172,
        longitude: 85.3240,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );
    }
  }

  void _createMarkers() {
    _markers.clear();

    // Add current location marker if available
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location'),
        ),
      );
    }

    // Add historical site markers
    for (final site in _getFilteredSites()) {
      _markers.add(
        Marker(
          markerId: MarkerId(site["id"] as String),
          position:
              LatLng(site["latitude"] as double, site["longitude"] as double),
          icon: _getMarkerIcon(site["type"] as String),
          onTap: () => _onMarkerTapped(site),
          infoWindow: InfoWindow(
            title: site["name"] as String,
            snippet: site["period"] as String,
          ),
        ),
      );
    }
  }

  BitmapDescriptor _getMarkerIcon(String type) {
    switch (type) {
      case 'temple':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'palace':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange);
      case 'monument':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'archaeological':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  List<Map<String, dynamic>> _getFilteredSites() {
    List<Map<String, dynamic>> filteredSites = _historicalSites;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredSites = filteredSites.where((site) {
        return (site["name"] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (site["location"] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply period filter
    if (_appliedFilters.containsKey('periods') &&
        (_appliedFilters['periods'] as List).isNotEmpty) {
      final selectedPeriods = _appliedFilters['periods'] as List<String>;
      filteredSites = filteredSites.where((site) {
        final sitePeriod = (site["period"] as String).toLowerCase();
        return selectedPeriods.any((period) => sitePeriod.contains(period));
      }).toList();
    }

    // Apply type filter
    if (_appliedFilters.containsKey('types') &&
        (_appliedFilters['types'] as List).isNotEmpty) {
      final selectedTypes = _appliedFilters['types'] as List<String>;
      filteredSites = filteredSites.where((site) {
        return selectedTypes.contains(site["type"]);
      }).toList();
    }

    // Apply radius filter
    if (_appliedFilters.containsKey('radius') && _currentPosition != null) {
      final radius = _appliedFilters['radius'] as double;
      filteredSites = filteredSites.where((site) {
        final distance = Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              site["latitude"] as double,
              site["longitude"] as double,
            ) /
            1000; // Convert to km
        return distance <= radius;
      }).toList();
    }

    return filteredSites;
  }

  void _onMarkerTapped(Map<String, dynamic> site) {
    setState(() {
      _selectedSite = site;
      _showPreviewCard = true;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          14.0,
        ),
      );
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _createMarkers();
  }

  void _onLayerChanged(MapLayerType layer) {
    setState(() {
      _currentLayer = layer;
    });
  }

  void _onCurrentLocationTap() async {
    if (_mapController != null && _currentPosition != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          16.0,
        ),
      );
    } else {
      await _getCurrentLocation();
      if (_currentPosition != null && _mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            16.0,
          ),
        );
      }
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MapFilterBottomSheet(
        onFiltersApplied: (filters) {
          setState(() {
            _appliedFilters = filters;
          });
          _createMarkers();
        },
      ),
    );
  }

  void _onSiteTap(Map<String, dynamic> site) {
    Navigator.pushNamed(
      context,
      '/content-detail-screen',
      arguments: site,
    );
  }

  void _onLearnMoreTap() {
    if (_selectedSite != null) {
      Navigator.pushNamed(
        context,
        '/content-detail-screen',
        arguments: _selectedSite,
      );
    }
  }

  MapType _getMapType() {
    switch (_currentLayer) {
      case MapLayerType.satellite:
        return MapType.satellite;
      case MapLayerType.terrain:
        return MapType.terrain;
      case MapLayerType.normal:
      default:
        return MapType.normal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? _buildLoadingState()
          : Stack(
              children: [
                _buildMap(),
                _buildSearchBar(),
                _buildLayerToggle(),
                if (_showPreviewCard && _selectedSite != null)
                  _buildPreviewCard(),
                _buildNearbySitesBottomSheet(),
              ],
            ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 3),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(height: 2.h),
            Text(
              'Loading Map...',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _currentPosition != null
            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
            : const LatLng(27.7172, 85.3240), // Default to Kathmandu
        zoom: 14.0,
      ),
      mapType: _getMapType(),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      onTap: (position) {
        setState(() {
          _showPreviewCard = false;
          _selectedSite = null;
        });
      },
      onLongPress: (position) {
        _showCustomPinDialog(position);
      },
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: MapSearchBar(
        onSearchChanged: _onSearchChanged,
        onFilterTap: _showFilterBottomSheet,
        onCurrentLocationTap: _onCurrentLocationTap,
      ),
    );
  }

  Widget _buildLayerToggle() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10.h,
      right: 0,
      child: MapLayerToggle(
        currentLayer: _currentLayer,
        onLayerChanged: _onLayerChanged,
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Positioned(
      bottom: 35.h,
      left: 0,
      right: 0,
      child: SitePreviewCard(
        site: _selectedSite!,
        onLearnMoreTap: _onLearnMoreTap,
        onCloseTap: () {
          setState(() {
            _showPreviewCard = false;
            _selectedSite = null;
          });
        },
      ),
    );
  }

  Widget _buildNearbySitesBottomSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: NearbySitesBottomSheet(
        sites: _getFilteredSites(),
        onSiteTap: _onSiteTap,
        onFilterTap: _showFilterBottomSheet,
      ),
    );
  }

  void _showCustomPinDialog(LatLng position) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Custom Pin',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Would you like to save this location for future exploration?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _addCustomPin(position);
              Navigator.pop(context);
            },
            child: Text('Save Pin'),
          ),
        ],
      ),
    );
  }

  void _addCustomPin(LatLng position) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('custom_${DateTime.now().millisecondsSinceEpoch}'),
          position: position,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          infoWindow: const InfoWindow(
            title: 'Custom Pin',
            snippet: 'Saved for exploration',
          ),
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Custom pin saved successfully!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }
}
