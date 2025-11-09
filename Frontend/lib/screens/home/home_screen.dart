// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../services/auth_service.dart';
// import '../auth/login_screen.dart';
// import '../sos/sos_screen.dart';
// import '../sos/my_sos_screen.dart';
// import '../family/family_contact_screen.dart';
// import '../sos/pending_sos_screen.dart';
// import '../family/family_dashboard_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);
//     final user = authService.user;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Arti SOS'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await authService.logout();
//               if (context.mounted) {
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(builder: (_) => const LoginScreen()),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Welcome, ${user?.name ?? "User"}!',
//                       style: Theme.of(context).textTheme.headlineSmall,
//                     ),
//                     const SizedBox(height: 8),
//                     Text('Role: ${user?.role ?? "N/A"}'),
//                     if (user?.email != null)
//                       Text('Email: ${user!.email}'),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             if (user?.role == 'user') ...[
//               _buildActionCard(
//                 context,
//                 title: 'Send SOS',
//                 icon: Icons.emergency,
//                 color: Colors.red,
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (_) => const SOSScreen()),
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),
//               _buildActionCard(
//                 context,
//                 title: 'My SOS History',
//                 icon: Icons.history,
//                 color: Colors.blue,
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (_) => const MySOSScreen()),
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),
//               _buildActionCard(
//                 context,
//                 title: 'Family Contact',
//                 icon: Icons.contacts,
//                 color: Colors.green,
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (_) => const FamilyContactScreen()),
//                   );
//                 },
//               ),
//             ],
//             if (user?.role == 'family') ...[
//               _buildActionCard(
//                 context,
//                 title: 'Track Family Members',
//                 icon: Icons.location_searching,
//                 color: Colors.purple,
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (_) => const FamilyDashboardScreen()),
//                   );
//                 },
//               ),
//             ],
//             if (user?.role == 'receiver') ...[
//               _buildActionCard(
//                 context,
//                 title: 'Pending SOS',
//                 icon: Icons.pending_actions,
//                 color: Colors.orange,
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (_) => const PendingSOSScreen()),
//                   );
//                 },
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionCard(
//     BuildContext context, {
//     required String title,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       elevation: 4,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(icon, color: color, size: 32),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Icon(Icons.arrow_forward_ios, color: color),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../services/auth_service.dart';
// import '../../models/sos_model.dart'; // Import SOS model
// import '../../services/sos_service.dart'; // Import SOSService
// import '../auth/login_screen.dart';
// import '../sos/sos_screen.dart';
// import '../sos/my_sos_screen.dart';
// import '../family/family_contact_screen.dart';
// import '../sos/pending_sos_screen.dart';
// import '../family/family_dashboard_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);
//     final user = authService.user;

//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.red[50],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(Icons.emergency, color: Colors.red[700], size: 24),
//             ),
//             const SizedBox(width: 12),
//             const Text(
//               'Arti SOS',
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(Icons.logout, color: Colors.black87, size: 20),
//             ),
//             onPressed: () async {
//               final shouldLogout = await showDialog<bool>(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: const Text('Logout'),
//                   content: const Text('Are you sure you want to logout?'),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context, false),
//                       child: const Text('Cancel'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () => Navigator.pop(context, true),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                       ),
//                       child: const Text('Logout'),
//                     ),
//                   ],
//                 ),
//               );

//               if (shouldLogout == true && context.mounted) {
//                 await authService.logout();
//                 if (context.mounted) {
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(builder: (_) => const LoginScreen()),
//                   );
//                 }
//               }
//             },
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Welcome Header
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Welcome back,',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     user?.name ?? "User",
//                     style: const TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: _getRoleColor(user?.role).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(
//                         color: _getRoleColor(user?.role).withOpacity(0.3),
//                         width: 1,
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           _getRoleIcon(user?.role),
//                           size: 16,
//                           color: _getRoleColor(user?.role),
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           _getRoleDisplayName(user?.role),
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: _getRoleColor(user?.role),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Grid Section
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Quick Actions',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   _buildActionGrid(context, user?.role),
                  
//                   // Emergency Call Buttons
//                   const SizedBox(height: 24),
//                   const Text(
//                     'Emergency Contacts',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildEmergencyButton(
//                           context,
//                           title: 'Police',
//                           icon: Icons.local_police,
//                           phoneNumber: '112',
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: _buildEmergencyButton(
//                           context,
//                           title: 'Ambulance',
//                           icon: Icons.local_hospital,
//                           phoneNumber: '108',
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmergencyButton(
//     BuildContext context, {
//     required String title,
//     required IconData icon,
//     required String phoneNumber,
//     required LinearGradient gradient,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () => _makeEmergencyCall(context, phoneNumber, title),
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           height: 85,
//           decoration: BoxDecoration(
//             gradient: gradient,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: gradient.colors.first.withOpacity(0.4),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Stack(
//             children: [
//               // Background decoration
//               Positioned(
//                 right: -10,
//                 top: -10,
//                 child: Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//               // Content
//               Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Icon(
//                         icon,
//                         color: Colors.white,
//                         size: 26,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _makeEmergencyCall(
//     BuildContext context,
//     String phoneNumber,
//     String serviceName,
//   ) async {
//     final uri = Uri(scheme: 'tel', path: phoneNumber);
    
//     try {
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri);
//       } else {
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Unable to call $serviceName'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error calling $serviceName: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   Widget _buildActionGrid(BuildContext context, String? role) {
//     List<ActionItem> actions = [];

//     if (role == 'user') {
//       actions = [
//         ActionItem(
//           title: 'Send SOS',
//           subtitle: 'Emergency alert',
//           icon: Icons.emergency,
//           gradient: const LinearGradient(
//             colors: [Color(0xFFEF5350), Color(0xFFE53935)],
//           ),
//           onTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(builder: (_) => const SOSScreen()),
//             );
//           },
//         ),
//         ActionItem(
//           title: 'SOS History',
//           subtitle: 'View past alerts',
//           icon: Icons.history,
//           gradient: const LinearGradient(
//             colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
//           ),
//           onTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(builder: (_) => const MySOSScreen()),
//             );
//           },
//         ),
//         ActionItem(
//           title: 'Family Contact',
//           subtitle: 'Manage contacts',
//           icon: Icons.contacts,
//           gradient: const LinearGradient(
//             colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
//           ),
//           onTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(builder: (_) => const FamilyContactScreen()),
//             );
//           },
//         ),
//       ];
//     } else if (role == 'family') {
//       // Instead of showing the "More" button, show the SOS alerts for family members
//       return FutureBuilder<List<SOS>>(
//         future: SOSService.getFamilySOS(), // Assuming this function exists
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else if (snapshot.hasData) {
//             final sosList = snapshot.data!;
//             return ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: sosList.length,
//               itemBuilder: (context, index) {
//                 final sos = sosList[index];
//                 return Card(
//                   child: ListTile(
//                     title: Text(sos.serviceType),
//                     subtitle: Text(sos.address ?? 'No address available'),
//                     // Add more details as needed
//                   ),
//                 );
//               },
//             );
//           } else {
//             return const Text('No SOS alerts found.');
//           }
//         },
//       );
//     } else if (role == 'receiver') {
//       actions = [
//         ActionItem(
//           title: 'Pending SOS',
//           subtitle: 'Respond to alerts',
//           icon: Icons.pending_actions,
//           gradient: const LinearGradient(
//             colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
//           ),
//           onTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(builder: (_) => const PendingSOSScreen()),
//             );
//           },
//         ),
//       ];
//     }
//     // Add "More" option
//     actions.add(
//       ActionItem(
//         title: 'More',
//         subtitle: 'Coming soon',
//         icon: Icons.more_vert,
//         gradient: const LinearGradient(
//           colors: [Color(0xFF90A4AE), Color(0xFF78909C)],
//         ),
//         onTap: () {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: const Text("Coming Soon!"),
//                 content: const Text("This feature is under development."),
//                 actions: [
//                   TextButton(
//                     child: const Text("OK"),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 1.3,
//       ),
//       itemCount: actions.length,
//       itemBuilder: (context, index) {
//         return _buildActionCard(context, actions[index]);
//       },
//     );
//   }

//   Widget _buildActionCard(BuildContext context, ActionItem item) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: item.onTap,
//         borderRadius: BorderRadius.circular(20),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: item.gradient,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: item.gradient.colors.first.withOpacity(0.3),
//                 blurRadius: 12,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: Stack(
//             children: [
//               // Background Pattern
//               Positioned(
//                 right: -15,
//                 top: -15,
//                 child: Container(
//                   width: 70,
//                   height: 70,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 right: 5,
//                 bottom: -5,
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//               // Content
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Icon(
//                         item.icon,
//                         color: Colors.white,
//                         size: 26,
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           item.title,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           item.subtitle,
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Colors.white.withOpacity(0.9),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Color _getRoleColor(String? role) {
//     switch (role) {
//       case 'user':
//         return Colors.blue;
//       case 'family':
//         return Colors.purple;
//       case 'receiver':
//         return Colors.orange;
//       default:
//         return Colors.grey;
//     }
//   }

//   IconData _getRoleIcon(String? role) {
//     switch (role) {
//       case 'user':
//         return Icons.person;
//       case 'family':
//         return Icons.family_restroom;
//       case 'receiver':
//         return Icons.support_agent;
//       default:
//         return Icons.account_circle;
//     }
//   }

//   String _getRoleDisplayName(String? role) {
//     switch (role) {
//       case 'user':
//         return 'User Account';
//       case 'family':
//         return 'Family Member';
//       case 'receiver':
//         return 'Emergency Responder';
//       default:
//         return 'Unknown Role';
//     }
//   }
// }

// class ActionItem {
//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final LinearGradient gradient;
//   final VoidCallback onTap;

//   ActionItem({
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.gradient,
//     required this.onTap,
//   });
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import '../sos/sos_screen.dart';
import '../sos/my_sos_screen.dart';
import '../family/family_contact_screen.dart';
import '../sos/pending_sos_screen.dart';
import '../family/family_dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.emergency, color: Colors.red[700], size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'Arti SOS',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.logout, color: Colors.black87, size: 20),
            ),
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true && context.mounted) {
                await authService.logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.name ?? "User",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getRoleColor(user?.role).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getRoleColor(user?.role).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getRoleIcon(user?.role),
                          size: 16,
                          color: _getRoleColor(user?.role),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _getRoleDisplayName(user?.role),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _getRoleColor(user?.role),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Grid Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActionGrid(context, user?.role),
                  
                  // Emergency Call Buttons
                  const SizedBox(height: 24),
                  const Text(
                    'Emergency Contacts',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildEmergencyButton(
                          context,
                          title: 'Police',
                          icon: Icons.local_police,
                          phoneNumber: '112',
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildEmergencyButton(
                          context,
                          title: 'Ambulance',
                          icon: Icons.local_hospital,
                          phoneNumber: '108',
                          gradient: const LinearGradient(
                            colors: [Color(0xFFD32F2F), Color(0xFFB71C1C)],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String phoneNumber,
    required LinearGradient gradient,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _makeEmergencyCall(context, phoneNumber, title),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background decoration
              Positioned(
                right: -10,
                top: -10,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makeEmergencyCall(
    BuildContext context,
    String phoneNumber,
    String serviceName,
  ) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unable to call $serviceName'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error calling $serviceName: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildActionGrid(BuildContext context, String? role) {
    List<ActionItem> actions = [];

    if (role == 'user') {
      actions = [
        ActionItem(
          title: 'Send SOS',
          subtitle: 'Emergency alert',
          icon: Icons.emergency,
          gradient: const LinearGradient(
            colors: [Color(0xFFEF5350), Color(0xFFE53935)],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SOSScreen()),
            );
          },
        ),
        ActionItem(
          title: 'SOS History',
          subtitle: 'View past alerts',
          icon: Icons.history,
          gradient: const LinearGradient(
            colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MySOSScreen()),
            );
          },
        ),
        ActionItem(
          title: 'Family Contact',
          subtitle: 'Manage contacts',
          icon: Icons.contacts,
          gradient: const LinearGradient(
            colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const FamilyContactScreen()),
            );
          },
        ),
        ActionItem(
          title: 'More',
          subtitle: 'Coming soon',
          icon: Icons.more_horiz,
          gradient: const LinearGradient(
            colors: [Color(0xFF90A4AE), Color(0xFF78909C)],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Coming Soon!"),
                  content: const Text("This feature is under development."),
                  actions: [
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ];
    } else if (role == 'family') {
      actions = [
        ActionItem(
          title: 'Track Members',
          subtitle: 'Real-time location',
          icon: Icons.location_searching,
          gradient: const LinearGradient(
            colors: [Color(0xFFAB47BC), Color(0xFF8E24AA)],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const FamilyDashboardScreen()),
            );
          },
        ),
        ActionItem(
          title: 'More',
          subtitle: 'Coming soon',
          icon: Icons.more_horiz,
          gradient: const LinearGradient(
            colors: [Color(0xFF90A4AE), Color(0xFF78909C)],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Coming Soon!"),
                  content: const Text("This feature is under development."),
                  actions: [
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ];
    } else if (role == 'receiver') {
      actions = [
        ActionItem(
          title: 'Pending SOS',
          subtitle: 'Respond to alerts',
          icon: Icons.pending_actions,
          gradient: const LinearGradient(
            colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PendingSOSScreen()),
            );
          },
        ),
        ActionItem(
          title: 'More',
          subtitle: 'Coming soon',
          icon: Icons.more_horiz,
          gradient: const LinearGradient(
            colors: [Color(0xFF90A4AE), Color(0xFF78909C)],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Coming Soon!"),
                  content: const Text("This feature is under development."),
                  actions: [
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ];
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return _buildActionCard(context, actions[index]);
      },
    );
  }

  Widget _buildActionCard(BuildContext context, ActionItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: item.gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: item.gradient.colors.first.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background Pattern
              Positioned(
                right: -12,
                top: -12,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 5,
                bottom: -5,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.icon,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'user':
        return Colors.blue;
      case 'family':
        return Colors.purple;
      case 'receiver':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(String? role) {
    switch (role) {
      case 'user':
        return Icons.person;
      case 'family':
        return Icons.family_restroom;
      case 'receiver':
        return Icons.support_agent;
      default:
        return Icons.account_circle;
    }
  }

  String _getRoleDisplayName(String? role) {
    switch (role) {
      case 'user':
        return 'User Account';
      case 'family':
        return 'Family Member';
      case 'receiver':
        return 'Emergency Responder';
      default:
        return 'Unknown Role';
    }
  }
}

class ActionItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  ActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });
}