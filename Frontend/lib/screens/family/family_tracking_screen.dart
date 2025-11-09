import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/family_service.dart';
import '../../services/location_service.dart';

class FamilyTrackingScreen extends StatefulWidget {
  final int userId;
  final String userName;

  const FamilyTrackingScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<FamilyTrackingScreen> createState() => _FamilyTrackingScreenState();
}

class _FamilyTrackingScreenState extends State<FamilyTrackingScreen> {
  GoogleMapController? _mapController;
  Map<String, dynamic>? _memberLocation;
  Position? _myLocation;
  bool _isLoading = true;
  String? _error;
  double _distance = 0.0;
  Set<Marker> _markers = {};
  LatLngBounds? _bounds;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Refresh location every 5 seconds
    _startPeriodicRefresh();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _startPeriodicRefresh() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _loadData();
        _startPeriodicRefresh();
      }
    });
  }

  Future<void> _loadData() async {
    // Get family member's current location
    final myPosition = await LocationService.getCurrentLocation();
    
    // Get tracked member's location
    final result = await FamilyService.getMemberLocation(widget.userId);

    setState(() {
      _isLoading = false;
      if (myPosition != null) {
        _myLocation = myPosition;
      }
      
      if (result['success'] == true) {
        _memberLocation = result['location'] as Map<String, dynamic>?;
        if (_memberLocation == null) {
          _error = 'No location data available';
        } else {
          _error = null;
          if (_myLocation != null) {
            _updateMap();
            _calculateDistance();
          }
        }
      } else {
        _error = result['message'] ?? 'Failed to load location';
      }
    });
    
    // Update map after state is set
    if (_myLocation != null && _memberLocation != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateMap();
        _calculateDistance();
      });
    }
  }

  void _updateMap() {
    if (_myLocation == null || _memberLocation == null) return;

    final myLatLng = LatLng(_myLocation!.latitude, _myLocation!.longitude);
    final memberLatLng = LatLng(
      (_memberLocation!['latitude'] as num).toDouble(),
      (_memberLocation!['longitude'] as num).toDouble(),
    );

    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('my_location'),
          position: myLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: 'Your Location',
            snippet: 'Family member tracking',
          ),
        ),
        Marker(
          markerId: MarkerId('member_${widget.userId}'),
          position: memberLatLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: widget.userName,
            snippet: _memberLocation!['address'] ?? 'Location',
          ),
        ),
      };

      // Calculate bounds to show both markers
      _bounds = LatLngBounds(
        southwest: LatLng(
          myLatLng.latitude < memberLatLng.latitude ? myLatLng.latitude : memberLatLng.latitude,
          myLatLng.longitude < memberLatLng.longitude ? myLatLng.longitude : memberLatLng.longitude,
        ),
        northeast: LatLng(
          myLatLng.latitude > memberLatLng.latitude ? myLatLng.latitude : memberLatLng.latitude,
          myLatLng.longitude > memberLatLng.longitude ? myLatLng.longitude : memberLatLng.longitude,
        ),
      );
    });

    // Update camera position to show both markers
    if (_mapController != null && _bounds != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(_bounds!, 100),
      );
    }
  }

  void _calculateDistance() {
    if (_myLocation == null || _memberLocation == null) return;

    final distanceInMeters = Geolocator.distanceBetween(
      _myLocation!.latitude,
      _myLocation!.longitude,
      (_memberLocation!['latitude'] as num).toDouble(),
      (_memberLocation!['longitude'] as num).toDouble(),
    );

    setState(() {
      _distance = distanceInMeters;
    });
  }

  String _formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} meters';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(2)} km';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track: ${widget.userName}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _memberLocation != null && _myLocation != null
                  ? Stack(
                      children: [
                        // Map View
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              (_memberLocation!['latitude'] as num).toDouble(),
                              (_memberLocation!['longitude'] as num).toDouble(),
                            ),
                            zoom: 14,
                          ),
                          markers: _markers,
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                            _updateMap();
                          },
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          mapType: MapType.normal,
                        ),
                        // Distance Card Overlay
                        Positioned(
                          top: 16,
                          left: 16,
                          right: 16,
                          child: Card(
                            elevation: 8,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.straighten,
                                        color: Colors.blue[700],
                                        size: 28,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Distance',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _formatDistance(_distance),
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[900],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Divider(),
                                  const SizedBox(height: 8),
                                  _buildInfoRow(
                                    'Tracked Member',
                                    widget.userName,
                                  ),
                                  if (_memberLocation!['address'] != null)
                                    _buildInfoRow(
                                      'Location',
                                      _memberLocation!['address'] as String,
                                    ),
                                  if (_memberLocation!['updated_at'] != null)
                                    _buildInfoRow(
                                      'Last Updated',
                                      _formatDateTime(_memberLocation!['updated_at']),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text('No location data available'),
                    ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(dynamic dateTime) {
    try {
      if (dateTime is String) {
        final dt = DateTime.parse(dateTime);
        return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
      }
      return dateTime.toString();
    } catch (e) {
      return dateTime.toString();
    }
  }
}

