// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:kmb_app/core/storage/secure_storage.dart';
// import 'package:kmb_app/core/auth/session_manager.dart';
// import 'package:kmb_app/features/provider/auth_provider.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

// class AppSidebar extends StatelessWidget {
//   const AppSidebar({super.key});

//   static const Color activeColor = Color(0xFF708CD6);

//   IconData _roleIcon(String? role) {
//     switch (role) {
//       case 'administrator':
//         return Icons.admin_panel_settings;
//       case 'chairman':
//         return Icons.account_circle;
//       case 'executive_chairman':
//         return Icons.workspace_premium;
//       case 'executive officer':
//         return Icons.work;
//       case 'dealings':
//         return Icons.handshake;
//       default:
//         return Icons.person;
//     }
//   }

//   Widget _navTile({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     String? route,
//     String? routeName,
//     VoidCallback? onTap,
//   }) {
//     final state = GoRouterState.of(context);
//     final location = state.uri.toString();

//     bool isActive = false;

//     if (routeName != null) {
//       isActive = state.name == routeName;
//     } else if (route != null) {
//       isActive = location.startsWith(route);
//     }

//     final theme = Theme.of(context);

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 250),
//       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: isActive
//             ? theme.colorScheme.primary.withOpacity(0.12)
//             : Colors.transparent,
//         borderRadius: BorderRadius.circular(12),
//         border: isActive
//             ? Border(
//                 left: BorderSide(width: 4, color: theme.colorScheme.primary),
//               )
//             : null,
//       ),
//       child: ListTile(
//         leading: Icon(
//           icon,
//           color: isActive
//               ? theme.colorScheme.primary
//               : theme.colorScheme.onSurface,
//         ),
//         title: Text(
//           title,
//           style: theme.textTheme.bodyMedium?.copyWith(
//             color: isActive
//                 ? theme.colorScheme.primary
//                 : theme.colorScheme.onSurface,
//             fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
//           ),
//         ),
//         onTap: () {
//           Navigator.pop(context);
//           if (routeName != null) {
//             context.goNamed(routeName);
//           } else if (route != null) {
//             context.go(route);
//           }
//         },
//       ),
//     );
//   }

//   Widget _switchRoleTile(BuildContext context) {
//     return Consumer<AuthProvider>(
//       builder: (context, auth, _) {
//         final session = auth.session;
//         if (session == null) return const SizedBox();

//         final theme = Theme.of(context);

//         return Container(
//           margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//           padding: const EdgeInsets.all(6),
//           decoration: BoxDecoration(
//             border: Border.all(color: theme.dividerColor),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton2<String>(
//               value: session.activeRole,
//               isExpanded: true,
//               alignment: Alignment.centerLeft,
//               buttonStyleData: const ButtonStyleData(
//                 padding: EdgeInsets.symmetric(horizontal: 8),
//                 height: 48,
//               ),
//               dropdownStyleData: DropdownStyleData(
//                 width: MediaQuery.of(context).size.width * 0.71,
//                 maxHeight: 250,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: theme.colorScheme.surface,
//                 ),
//               ),
//               items: session.roles.map((role) {
//                 return DropdownMenuItem(
//                   value: role,
//                   child: Row(
//                     children: [
//                       Icon(_roleIcon(role), color: theme.colorScheme.primary),
//                       const SizedBox(width: 8),
//                       Text(
//                         role.toUpperCase(),
//                         style: TextStyle(color: theme.colorScheme.onSurface),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//               onChanged: (role) async {
//                 if (role == null || role == session.activeRole) return;

//                 final scaffoldMessenger = ScaffoldMessenger.of(context);

//                 showDialog(
//                   context: context,
//                   barrierDismissible: false,
//                   builder: (_) =>
//                       const Center(child: CircularProgressIndicator()),
//                 );

//                 try {
//                   await auth.switchRole(role);

//                   if (!context.mounted) return;

//                   Navigator.pop(context);
//                   Navigator.pop(context);

//                   scaffoldMessenger.showSnackBar(
//                     SnackBar(content: Text("Switched to $role")),
//                   );

//                   context.goNamed(SessionManager.homeRouteName);
//                 } catch (e) {
//                   if (!context.mounted) return;

//                   Navigator.pop(context);

//                   scaffoldMessenger.showSnackBar(
//                     SnackBar(
//                       content: Text(e.toString().replaceAll('Exception: ', '')),
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();
//     final session = auth.session;

//     final canSeeAdmin =
//         session?.normalizedRole == 'administrator' ||
//         session?.normalizedRole == 'super_admin';

//     final theme = Theme.of(context);

//     return Drawer(
//       backgroundColor: theme.colorScheme.surface,
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(color: theme.colorScheme.primary),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 28,
//                   backgroundColor: theme.colorScheme.surface,
//                   child: Icon(
//                     _roleIcon(session?.activeRole),
//                     color: theme.colorScheme.primary,
//                     size: 40,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     'Hi! ${session?.activeRole.toUpperCase() ?? 'GUEST'}',
//                     style: theme.textTheme.titleMedium?.copyWith(
//                       color: theme.colorScheme.onPrimary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           _switchRoleTile(context),

//           _navTile(
//             context: context,
//             icon: Icons.home,
//             title: 'Home',
//             routeName: SessionManager.homeRouteName,
//           ),
//           _navTile(
//             context: context,
//             icon: Icons.person,
//             title: 'Owners',
//             route: '/list/owner',
//           ),
//           _navTile(
//             context: context,
//             icon: Icons.drive_eta_rounded,
//             title: 'Drivers',
//             route: '/list/driver',
//           ),
//           _navTile(
//             context: context,
//             icon: Icons.electric_rickshaw,
//             title: 'E-Rickshaw',
//             route: '/list/vehicle',
//           ),
//           _navTile(
//             context: context,
//             icon: Icons.assignment,
//             title: 'Permit Applications',
//             route: '/application/list',
//           ),

//           ListTile(
//             leading: Icon(Icons.logout, color: theme.colorScheme.onSurface),
//             title: Text(
//               'Logout',
//               style: TextStyle(color: theme.colorScheme.onSurface),
//             ),
//             onTap: () async {
//               await SecureStorage.clearAll();
//               auth.logout();

//               if (!context.mounted) return;

//               Navigator.pop(context);

//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Logged out successfully')),
//               );
//             },
//           ),

//           if (canSeeAdmin) ...[
//             Divider(color: theme.dividerColor),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
//               child: Text(
//                 'ADMINISTRATION',
//                 style: theme.textTheme.labelSmall?.copyWith(
//                   color: theme.colorScheme.onSurface.withOpacity(0.6),
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1,
//                 ),
//               ),
//             ),
//             _navTile(
//               context: context,
//               icon: Icons.people,
//               title: 'Users',
//               route: '/admin_users',
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kmb_app/core/storage/secure_storage.dart';
import 'package:kmb_app/core/auth/session_manager.dart';
import 'package:kmb_app/features/provider/auth_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'dart:ui';
import 'package:flutter/material.dart';

class Blob extends StatelessWidget {
  final double size;
  final Alignment alignment;
  final List<Color>? colors;
  final double opacity;
  final double blur;
  final bool animate;
  final Duration duration;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  const Blob({
    super.key,
    required this.size,
    this.alignment = Alignment.center,
    this.colors,
    this.opacity = 0.3,
    this.blur = 0,
    this.animate = false,
    this.duration = const Duration(seconds: 6),
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final blob = AnimatedContainer(
      duration: animate ? duration : Duration.zero,
      curve: Curves.easeInOut,
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: border,
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: (colors?.first ?? theme.colorScheme.primary).withOpacity(
                  0.25,
                ),
                blurRadius: 40,
                spreadRadius: -10,
              ),
            ],
        gradient: RadialGradient(
          colors:
              colors ??
              [
                theme.colorScheme.primary.withOpacity(opacity),
                Colors.transparent,
              ],
        ),
      ),
    );

    return Align(
      alignment: alignment,
      child: blur > 0
          ? ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: blob,
              ),
            )
          : blob,
    );
  }
}

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  static const _tileMargin = EdgeInsets.symmetric(horizontal: 8, vertical: 4);

  // ----------------------------------------------------------
  // Role Icon
  // ----------------------------------------------------------

  IconData _roleIcon(String? role) {
    switch (role) {
      case 'administrator':
        return Icons.admin_panel_settings;
      case 'chairman':
        return Icons.account_circle;
      case 'executive_chairman':
        return Icons.workspace_premium;
      case 'executive officer':
        return Icons.work;
      case 'dealings':
        return Icons.handshake;
      default:
        return Icons.person;
    }
  }
  // ----------------------------------------------------------
  // Role Image (Animated)
  // ----------------------------------------------------------

  String _roleImage(String? role) {
    switch (role) {
      case 'administrator':
        return 'assets/roles/administrator.png';
      case 'chairman':
        return 'assets/roles/chairman.png';
      case 'executive_chairman':
        return 'assets/roles/executive.png';
      case 'executive officer':
        return 'assets/roles/executive.png';
      case 'dealings':
        return 'assets/roles/dealing.png';
      default:
        return 'assets/roles/user.png';
    }
  }

  // ----------------------------------------------------------
  // Navigation Tile
  // ----------------------------------------------------------

  Widget _navTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? route,
    String? routeName,
    VoidCallback? onTap,
  }) {
    final state = GoRouterState.of(context);
    final location = state.uri.toString();
    final theme = Theme.of(context);

    bool isActive = false;

    if (routeName != null) {
      isActive = state.name == routeName;
    } else if (route != null) {
      isActive = location.startsWith(route);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: _tileMargin,
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary.withOpacity(0.10)
            : Colors.transparent,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.25),
                  blurRadius: 25,
                  spreadRadius: -20,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,

        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? Border(
                left: BorderSide(width: 4, color: theme.colorScheme.primary),
              )
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(
          icon,
          color: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface,
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          Navigator.pop(context);

          if (onTap != null) {
            onTap();
            return;
          }

          if (routeName != null) {
            context.goNamed(routeName);
          } else if (route != null) {
            context.go(route);
          }
        },
      ),
    );
  }

  // ----------------------------------------------------------
  // Section Header
  // ----------------------------------------------------------

  Widget _sectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 20, bottom: 6),
      child: Text(
        title,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // Role Switch Dropdown
  // ----------------------------------------------------------

  Widget _switchRoleTile(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final session = auth.session;
        if (session == null) return const SizedBox();

        final theme = Theme.of(context);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: session.activeRole,
              isExpanded: true,
              alignment: Alignment.centerLeft,
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 8),
                height: 48,
              ),
              dropdownStyleData: DropdownStyleData(
                width: MediaQuery.of(context).size.width * 0.7,
                maxHeight: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surface,
                ),
              ),
              items: session.roles.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Row(
                    children: [
                      Icon(_roleIcon(role), color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        role.toUpperCase(),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (role) async {
                if (role == null || role == session.activeRole) return;

                final messenger = ScaffoldMessenger.of(context);

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );

                try {
                  await auth.switchRole(role);

                  if (!context.mounted) return;

                  Navigator.pop(context);
                  Navigator.pop(context);

                  messenger.showSnackBar(
                    SnackBar(content: Text("Switched to $role")),
                  );

                  context.goNamed(SessionManager.homeRouteName);
                } catch (e) {
                  if (!context.mounted) return;

                  Navigator.pop(context);

                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceAll('Exception: ', '')),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final session = auth.session;

    final canSeeAdmin =
        session?.normalizedRole == 'administrator' ||
        session?.normalizedRole == 'super_admin';

    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: Stack(
        children: [
          /// 🔵 BACKGROUND BLOBS
          // Blob(
          //   size: 220,
          //   alignment: Alignment.topRight,
          //   colors: [
          //     theme.colorScheme.primary.withOpacity(0.15),
          //     Colors.transparent,
          //   ],
          // ),
          Blob(
            size: 200,
            alignment: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 222, 236, 253).withOpacity(0.4),

              Colors.transparent,
            ],
          ),

          ListView(
            padding: EdgeInsets.zero,
            children: [
              /// ================= HEADER =================
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withOpacity(0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    /// Header Blob
                    Positioned(
                      right: -40,
                      top: -30,
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Animated Avatar
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            key: ValueKey(session?.activeRole),
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.9),
                                  Colors.white.withOpacity(0.6),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              _roleImage(session?.activeRole),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          'Hi, ${session?.activeRole.toUpperCase() ?? 'GUEST'}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              _switchRoleTile(context),

              /// ================= NAVIGATION =================
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
                route: '/application/list',
              ),

              _navTile(
                context: context,
                icon: Icons.logout,
                title: 'Logout',
                onTap: () async {
                  await SecureStorage.clearAll();
                  auth.logout();

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out successfully')),
                  );
                },
              ),

              if (canSeeAdmin) ...[
                const SizedBox(height: 12),
                Divider(color: theme.dividerColor),
                _sectionHeader(context, 'ADMINISTRATION'),
                _navTile(
                  context: context,
                  icon: Icons.people,
                  title: 'Users',
                  route: '/admin_users',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
