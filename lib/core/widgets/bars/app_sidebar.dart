import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kmb_app/core/storage/secure_storage.dart';
import 'package:kmb_app/core/auth/session_manager.dart';
import 'package:kmb_app/features/provider/auth_provider.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  static const Color activeColor = Color(0xFF708CD6);

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

  Widget _navTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? route,
    String? routeName,
  }) {
    final location = GoRouterState.of(context).uri.toString();
    bool isActive = false;

    if (routeName != null) {
      isActive = location.contains(routeName);
    } else if (route != null) {
      isActive = location.startsWith(route);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? activeColor.withOpacity(0.14) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? const Border(left: BorderSide(width: 4, color: activeColor))
            : null,
      ),
      child: ListTile(
        leading: Icon(icon, color: isActive ? activeColor : Colors.black54),
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

  Widget _switchRoleTile(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final session = auth.session;
        if (session == null) return const SizedBox();

        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: session.activeRole,
              isExpanded: true,
              items: session.roles.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Row(
                    children: [
                      Icon(_roleIcon(role), color: activeColor),
                      const SizedBox(width: 8),
                      Text(role.toUpperCase()),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (role) async {
                if (role == null || role == session.activeRole) return;

                final scaffoldMessenger = ScaffoldMessenger.of(context);

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );

                try {
                  await auth.switchRole(role);

                  if (!context.mounted) return;

                  Navigator.pop(context); // close loading
                  Navigator.pop(context); // close drawer

                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text("Switched to $role")),
                  );

                  context.goNamed(SessionManager.homeRouteName);
                } catch (e) {
                  if (!context.mounted) return;

                  Navigator.pop(context); // close loading

                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString().replaceAll('Exception: ', ''),
                      ),
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

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final session = auth.session;

    final canSeeAdmin =
        session?.normalizedRole == 'administrator' ||
            session?.normalizedRole == 'super_admin';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 163, 105, 240)),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(
                    _roleIcon(session?.activeRole),
                    color: activeColor,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Hi! ${session?.activeRole.toUpperCase() ?? 'GUEST'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// ROLE SWITCH
          _switchRoleTile(context),

          /// MAIN MENU
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

          /// LOGOUT
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await SecureStorage.clearAll();
              auth.logout();

              if (!context.mounted) return;

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                ),
              );
            },
          ),

          /// ADMIN SECTION
          if (canSeeAdmin) ...[
            const Divider(),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
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
          ],
        ],
      ),
    );
  }
}
