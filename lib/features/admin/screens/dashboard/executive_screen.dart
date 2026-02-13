import 'package:flutter/material.dart';
import 'package:kmb_app/shared/day_night_toggle.dart';
import 'package:provider/provider.dart';
import 'package:kmb_app/core/auth/user_role.dart';

import 'package:kmb_app/features/admin/widgets/dashboard_widgets.dart';
import 'package:kmb_app/shared/back_button_handler.dart';

import '../../../../core/widgets/bars/app_sidebar.dart';
import '../../../../core/widgets/bars/app_bottom_bar.dart';
import '../../../provider/auth_provider.dart';

class Executivedashboardpage extends StatefulWidget {
  const Executivedashboardpage({super.key});

  @override
  State<Executivedashboardpage> createState() => _ExecutivedashboardpageState();
}

class _ExecutivedashboardpageState extends State<Executivedashboardpage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthProvider>().role;

    return BackButtonHandler(
      isRoot: true,
      child: Scaffold(
         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: AppSidebar(),

        appBar: AppBar(
          actions: [
                    
              Padding(
              padding: EdgeInsets.only(right: 16),
              child: DayNightToggle(),
           )
          ],
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
        children: const [DashboardWidgets()],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: Executivedashboardpage()));
}
