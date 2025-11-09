import 'package:flutter/material.dart';
import '../../services/location_service.dart';
import '../../services/sos_service.dart';
import '../../services/family_service.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedServiceType = 'police';
  bool _isLoading = false;
  double? _latitude;
  double? _longitude;
  String? _locationStatus;
  String? _locationAddress;

  final List<Map<String, String>> _serviceTypes = [
    {'value': 'police', 'label': 'Police'},
    {'value': 'ambulance', 'label': 'Ambulance'},
    {'value': 'fire', 'label': 'Fire Department'},
    {'value': 'family', 'label': 'Family (Only notified)'},
  ];

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _locationStatus = 'Getting location...';
      _locationAddress = null;
    });

    try {
      final position = await LocationService.getCurrentLocation();
      
      if (position != null) {
        _latitude = position.latitude;
        _longitude = position.longitude;
        
        // Get address from coordinates using backend
        setState(() {
          _locationStatus = 'Getting address...';
        });
        
        try {
          final addressResult = await SOSService.getAddressFromCoordinates(
            latitude: _latitude!,
            longitude: _longitude!,
          );
          
          if (addressResult['success'] == true && addressResult['address'] != null) {
            setState(() {
              _locationAddress = addressResult['address'] as String;
              _locationStatus = 'Location obtained';
              _isLoading = false;
            });
          } else {
            // If address is not available, show coordinates as fallback
            setState(() {
              _locationAddress = '${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}';
              _locationStatus = 'Location obtained (address unavailable)';
              _isLoading = false;
            });
          }
        } catch (e) {
          // If reverse geocoding fails, show coordinates as fallback
          setState(() {
            _locationAddress = '${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}';
            _locationStatus = 'Location obtained (address unavailable)';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _locationStatus = 'Failed to get location. Please enable location services.';
          _locationAddress = null;
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to get location. Please enable location services.'),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _locationStatus = 'Error getting location: $e';
        _locationAddress = null;
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _sendSOS() async {
    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please get your location first'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await SOSService.sendSOS(
        serviceType: _selectedServiceType,
        latitude: _latitude!,
        longitude: _longitude!,
      );

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (result['success'] == true) {
        // Also share location with family members
        try {
          await FamilyService.shareLocation(
            latitude: _latitude!,
            longitude: _longitude!,
          );
        } catch (e) {
          // Ignore family sharing errors
          print('Error sharing with family: $e');
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SOS sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to send SOS'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send SOS'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.emergency,
                size: 100,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              const Text(
                'Emergency SOS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Service Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedServiceType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _serviceTypes.map((service) {
                  return DropdownMenuItem<String>(
                    value: service['value'],
                    child: Text(service['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedServiceType = value);
                  }
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _getCurrentLocation,
                icon: const Icon(Icons.location_on),
                label: const Text('Get Current Location'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              if (_locationStatus != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _locationStatus!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
              if (_locationAddress != null) ...[
                const SizedBox(height: 12),
                Card(
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.green[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Location:',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _locationAddress!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green[900],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendSOS,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'SEND SOS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

