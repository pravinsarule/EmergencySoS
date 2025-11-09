import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/sos_model.dart';
import '../../services/sos_service.dart';

class MySOSScreen extends StatefulWidget {
  const MySOSScreen({super.key});

  @override
  State<MySOSScreen> createState() => _MySOSScreenState();
}

class _MySOSScreenState extends State<MySOSScreen> {
  List<SOS> _sosList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSOS();
  }

  Future<void> _loadSOS() async {
    setState(() => _isLoading = true);

    final result = await SOSService.getMySOS();

    setState(() {
      _isLoading = false;
      if (result['success'] == true) {
        _sosList = result['list'] as List<SOS>;
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Failed to load SOS')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My SOS History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSOS,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sosList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No SOS requests found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadSOS,
                  child: ListView.builder(
                    itemCount: _sosList.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final sos = _sosList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getStatusColor(sos.status),
                            child: Icon(
                              Icons.emergency,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            sos.serviceType.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Status: ${sos.status}'),
                              Text(
                                sos.address != null && sos.address!.isNotEmpty
                                    ? 'Location: ${sos.address}'
                                    : 'Location: ${sos.latitude.toStringAsFixed(6)}, ${sos.longitude.toStringAsFixed(6)}',
                              ),
                              Text(
                                'Time: ${DateFormat('MMM dd, yyyy HH:mm').format(sos.createdAt)}',
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

