import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kmb_app/core/auth/user_role.dart';

import 'package:kmb_app/features/admin/widgets/dashboard_widgets.dart';
import 'package:kmb_app/shared/back_button_handler.dart';

import '../../../../core/widgets/bars/app_sidebar.dart';
import '../../../../core/widgets/bars/app_bottom_bar.dart';
import '../../../provider/auth_provider.dart';


class SuperAdminDashboard extends StatefulWidget {
  const SuperAdminDashboard({super.key});

  @override
  State<SuperAdminDashboard> createState() => _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
     final auth = context.watch<AuthProvider>(); 
    final role = auth.role;


    return BackButtonHandler(
      isRoot: true,
      child: Scaffold(
        drawer: AppSidebar(), 

        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                role?.displayName ?? 'Dashboard',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            _HomeDashboardPage(),
            Center(child: Text('Notifications Page')),
            Center(child: Text('Profile Page')),
          ],
        ),

        bottomNavigationBar: AppBottomBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}


//
class _HomeDashboardPage extends StatelessWidget {
  const _HomeDashboardPage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          DashboardWidgets(),
        ],
      ),
    );
  }
}


// 700