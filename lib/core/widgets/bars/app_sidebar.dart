// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:kmb_app/core/storage/secure_storage.dart';
// import 'package:kmb_app/core/auth/session_manager.dart';

// class AppSidebar extends StatefulWidget {
//   const AppSidebar({super.key});


  

//   @override
//   State<AppSidebar> createState() => _AppSidebarState();
// }

// class _AppSidebarState extends State<AppSidebar> {
//   @override
//   Widget build(BuildContext context) {
//     // final session = SessionManager.session;
//     final canSeeAdmin = SessionManager.isAdmin;
//     final  ValueNotifier<bool> isLoggedOutNotifier = ValueNotifier(false);
//     final String location = GoRouterState.of(context).uri.toString();
    

//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: const BoxDecoration(
//               color: Color.fromARGB(255, 112, 140, 214),
//             ),
//             child: ValueListenableBuilder(
//               valueListenable: SessionManager.sessionNotifier,
//               builder: (context, session, _) {
//                 return Text(
//                   'Hi! ${session?.activeRole.toUpperCase() ?? ''}',
//                   style: const TextStyle(color: Colors.white, fontSize: 18),
//                 );
//               }
//             ),
//           ),

//           /// ---------------- MAIN ----------------
//           ListTile(
//             leading: const Icon(Icons.home),
          
//             title: const Text('Home'),
//             onTap: () {
//               Navigator.pop(context);
//               context.goNamed(SessionManager.homeRouteName);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text('Owners'),
//             onTap: () {
//               Navigator.pop(context);
//               context.goNamed('owner_list');
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.drive_eta_rounded),
//             title: const Text('Drivers'),
//             onTap: () {
//               Navigator.pop(context);
//               context.goNamed('driver_list');
//             },
//           ),

//           ListTile(
//             leading: const Icon(Icons.electric_rickshaw),
//             title: const Text('E-Rickshaw'),
//             onTap: () {
//               Navigator.pop(context);
//               context.goNamed('vehicle_list');
//             },
//           ),

//           ListTile(
//             leading: const Icon(Icons.assignment),
//             title: const Text('Permit Applications'),
//             onTap: () {
//               Navigator.pop(context); 
//               context.goNamed('application_details');
//             },
//           ),

//           ListTile(
//             leading: const Icon(Icons.payment),
//             title: const Text('Payments'),
//             onTap: () => Navigator.pop(context),
//           ),

//           /// ---------------- LOGOUT ----------------
//           ListTile(
//             leading: const Icon(Icons.logout),
//             title: const Text('Logout'),
//             onTap: () async {
//               await SecureStorage.clearAll();
//                 isLoggedOutNotifier.value = true;

//               // Show snackbar
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Logged out successfully'),
//                   duration: Duration(seconds: 2),
//                 ),
//               );

//               // Wait a little for the snackbar to show before navigation (optional)
//               await Future.delayed(const Duration(milliseconds: 200));

//               context.goNamed('login');
//             },
//           ),


//           /// ---------------- ADMINISTRATION ----------------
//           if (canSeeAdmin) ...[
//             const Divider(),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
//               child: Text(
//                 'ADMINISTRATION',
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey,
//                   letterSpacing: 1,
//                 ),
//               ),
//             ),

//             ListTile(
//               leading: const Icon(Icons.people),
//               title: const Text('Users'),
//               onTap: () => Navigator.pop(context),
//               // onTap: () => context.goNamed('admin_users'),
//             ),

//             ListTile(
//               leading: const Icon(Icons.security),
//               title: const Text('Roles'),
//               onTap: () => Navigator.pop(context),
//               // onTap: () => context.goNamed('admin_roles'),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }








import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kmb_app/core/storage/secure_storage.dart';
import 'package:kmb_app/core/auth/session_manager.dart';
import 'package:kmb_app/features/auth/models/session.dart';

class AppSidebar extends StatefulWidget {
  const AppSidebar({super.key});

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  final Color activeColor = const Color(0xFF708CD6);
   




  bool _isAnyTabActive(BuildContext context) {


  final location = GoRouterState.of(context).uri.toString();

  final routes = [
    '/dashboard/superAdmin',
    '/list/owner',
    '/list/driver',
    '/list/vehicle',
    '/details/application',
    '/admin_users',
    '/admin_roles',
  ];

  return routes.any((r) => location.startsWith(r));
}

  // ---------------- NAV TILE ----------------
  Widget _navTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? route,
    String? routeName,
  }) {
    final String location = GoRouterState.of(context).uri.toString();
    bool isActive = false;

    bool _drawerOpenedOnce = false;

    


  if (!_drawerOpenedOnce) {
    _drawerOpenedOnce = true;
  }
    if (routeName != null) {
      isActive = location.contains(routeName);
    }
    if (route != null) {
      isActive = location.startsWith(route);
    }

      // Default to Home if nothing matches
    // if (!isActive && title == 'Home') {
    //   isActive = true;
    // }


      //  DEFAULT: If no other tab is active, set Home active
  // Only apply default active when drawer opens and nothing matches
  // Only apply default active when drawer opens and nothing matches
  // if (!isActive && defaultActive && !drawerOpenedOnce) {
  //   isActive = true;
  // }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? activeColor.withOpacity(0.14) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? Border(
                left: BorderSide(
                  width: 4,
                  color: activeColor,
                ),
              )
            : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? activeColor : Colors.black54,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? activeColor : Colors.black87,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          if (routeName != null) {
            context.goNamed(routeName);
          } else if (route != null) {
            context.go(route);
          }
        },
      ),
    );
  }

  // ---------------- ROLE ICON ----------------
  IconData _roleIcon(String? role) {
    switch (role) {
      case 'administrator':
        return Icons.admin_panel_settings;
      case 'chairman':
        return Icons.account_circle;
      case 'executive_officer':
        return Icons.work;
      case 'dealings':
        return Icons.handshake;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSeeAdmin = SessionManager.isAdmin;
    bool _animatedOnce =false;


    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 163, 105, 240),
              ),
              child: ValueListenableBuilder<Session?>(
                valueListenable: SessionManager.sessionNotifier,
                builder: (context, session, _) {
                  if (!_animatedOnce) {
                    _animatedOnce = true;
                  }
                  
                  return Row(
                    children: [
                      //  CircleAvatar with role icon
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Icon(
                          _roleIcon(session?.activeRole),
                          color: const Color(0xFF708CD6),
                          size: 50,
                          
                        ),
                      ),
            
                      const SizedBox(width: 12),
            
                      Expanded(
                        
                        child: AnimatedSwitcher(
            
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                          );
                        },
                          child: Text(
                            'Hi! ${session?.activeRole.toUpperCase() ?? 'GUEST'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          /// ---------------- MAIN ----------------
          _navTile(
            context: context,
            icon: Icons.home,
            title: 'Home',
            routeName: SessionManager.homeRouteName,
          ),

          _navTile(
            context: context,
            icon: Icons.person,
            title: 'Owners',
            route: '/list/owner',
          ),

          _navTile(
            context: context,
            icon: Icons.drive_eta_rounded,
            title: 'Drivers',
            route: '/list/driver',
          ),

          _navTile(
            context: context,
            icon: Icons.electric_rickshaw,
            title: 'E-Rickshaw',
            route: '/list/vehicle',
          ),

          _navTile(
            context: context,
            icon: Icons.assignment,
            title: 'Permit Applications',
            route: '/details/application',
          ),

          /// ---------------- LOGOUT ----------------
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await SecureStorage.clearAll();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  duration: Duration(seconds: 2),
                ),
              );

              await Future.delayed(const Duration(milliseconds: 200));
              context.goNamed('login');
            },
          ),

          /// ---------------- ADMINISTRATION ----------------
          if (canSeeAdmin) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                'ADMINISTRATION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
            ),
            _navTile(
              context: context,
              icon: Icons.people,
              title: 'Users',
              route: '/admin_users',
            ),
            _navTile(
              context: context,
              icon: Icons.security,
              title: 'Roles',
              route: '/admin_roles',
            ),
          ],
        ],
      ),
    );
  }
}
