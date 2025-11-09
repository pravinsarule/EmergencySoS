import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

class FamilyContactScreen extends StatefulWidget {
  const FamilyContactScreen({super.key});

  @override
  State<FamilyContactScreen> createState() => _FamilyContactScreenState();
}

class _FamilyContactScreenState extends State<FamilyContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _familyEmailController = TextEditingController();
  final _familyPhoneController = TextEditingController();
  final _familyNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _familyEmailController.dispose();
    _familyPhoneController.dispose();
    _familyNameController.dispose();
    super.dispose();
  }

  Future<void> _saveFamilyContact() async {
    if (!_formKey.currentState!.validate()) return;

    if (_familyEmailController.text.trim().isEmpty && _familyPhoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter family email or phone'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
    final result = await authService.saveFamilyContact(
      familyEmail: _familyEmailController.text.trim().isEmpty ? null : _familyEmailController.text.trim(),
      familyPhone: _familyPhoneController.text.trim().isEmpty ? null : _familyPhoneController.text.trim(),
      familyName: _familyNameController.text.trim().isEmpty ? null : _familyNameController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Family contact saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      _familyEmailController.clear();
      _familyPhoneController.clear();
      _familyNameController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to save contact'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Contact'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.contacts,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              const Text(
                'Emergency Family Contact',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add a family member who can track your location. They must be registered with "family" role.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _familyEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Family Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  helperText: 'Enter family member\'s email (or phone)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _familyPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Family Phone',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                  helperText: 'Enter family member\'s phone (or email)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _familyNameController,
                decoration: const InputDecoration(
                  labelText: 'Family Name (Optional)',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveFamilyContact,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Save Family Contact',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

