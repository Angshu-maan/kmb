import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kmb_app/core/storage/secure_storage.dart';
import 'package:kmb_app/core/auth/session_manager.dart';
import 'package:kmb_app/features/provider/auth_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
    final state = GoRouterState.of(context);
    final location = state.uri.toString();

    bool isActive = false;

    if (routeName != null) {
      isActive = state.name == routeName;
    } else if (route != null) {
      isActive = location.startsWith(route);
    }

    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary.withOpacity(0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? Border(
                left: BorderSide(
                  width: 4,
                  color: theme.colorScheme.primary,
                ),
              )
            : null,
      ),
      child: ListTile(
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
            fontWeight:
                isActive ? FontWeight.w700 : FontWeight.normal,
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

        final theme = Theme.of(context);

        return Container(
          margin:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                width:
                    MediaQuery.of(context).size.width * 0.71,
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
                      Icon(
                        _roleIcon(role),
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        role.toUpperCase(),
                        style: TextStyle(
                          color:
                              theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (role) async {
                if (role == null ||
                    role == session.activeRole) return;

                final scaffoldMessenger =
                    ScaffoldMessenger.of(context);

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                try {
                  await auth.switchRole(role);

                  if (!context.mounted) return;

                  Navigator.pop(context);
                  Navigator.pop(context);

                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                          "Switched to $role"),
                    ),
                  );

                  context.goNamed(
                      SessionManager.homeRouteName);
                } catch (e) {
                  if (!context.mounted) return;

                  Navigator.pop(context);

                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString()
                            .replaceAll(
                                'Exception: ', ''),
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

    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      theme.colorScheme.surface,
                  child: Icon(
                    _roleIcon(session?.activeRole),
                    color:
                        theme.colorScheme.primary,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Hi! ${session?.activeRole.toUpperCase() ?? 'GUEST'}',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(
                      color:
                          theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          _switchRoleTile(context),

          _navTile(
            context: context,
            icon: Icons.home,
            title: 'Home',
            routeName:
                SessionManager.homeRouteName,
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

          ListTile(
            leading: Icon(
              Icons.logout,
              color: theme.colorScheme.onSurface,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                  color:
                      theme.colorScheme.onSurface),
            ),
            onTap: () async {
              await SecureStorage.clearAll();
              auth.logout();

              if (!context.mounted) return;

              Navigator.pop(context);

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                      'Logged out successfully'),
                ),
              );
            },
          ),

          if (canSeeAdmin) ...[
            Divider(color: theme.dividerColor),
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                      16, 8, 16, 4),
              child: Text(
                'ADMINISTRATION',
                style: theme.textTheme.labelSmall
                    ?.copyWith(
                  color: theme
                      .colorScheme.onSurface
                      .withOpacity(0.6),
                  fontWeight: FontWeight.bold,
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
