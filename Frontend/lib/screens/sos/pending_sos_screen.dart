import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/sos_model.dart';
import '../../services/sos_service.dart';

class PendingSOSScreen extends StatefulWidget {
  const PendingSOSScreen({super.key});

  @override
  State<PendingSOSScreen> createState() => _PendingSOSScreenState();
}

class _PendingSOSScreenState extends State<PendingSOSScreen> {
  List<SOS> _sosList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingSOS();
  }

  Future<void> _loadPendingSOS() async {
    setState(() => _isLoading = true);

    final result = await SOSService.getPendingSOS();

    setState(() {
      _isLoading = false;
      if (result['success'] == true) {
        _sosList = result['list'] as List<SOS>;
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to load pending SOS'),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending SOS Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPendingSOS,
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
                        Icons.check_circle,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No pending SOS requests',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadPendingSOS,
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
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: const Icon(
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
                          subtitle: Text(
                            'From: ${sos.userName ?? "Unknown"}',
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow('User', sos.userName ?? 'N/A'),
                                  if (sos.userPhone != null)
                                    _buildInfoRow('Phone', sos.userPhone!),
                                  _buildInfoRow(
                                    'Location',
                                    sos.address != null && sos.address!.isNotEmpty
                                        ? sos.address!
                                        : '${sos.latitude.toStringAsFixed(6)}, ${sos.longitude.toStringAsFixed(6)}',
                                  ),
                                  _buildInfoRow(
                                    'Time',
                                    DateFormat('MMM dd, yyyy HH:mm')
                                        .format(sos.createdAt),
                                  ),
                                  _buildInfoRow('Status', sos.status),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
            width: 80,
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
}

