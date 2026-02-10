import 'package:flutter/material.dart';
import '../../../../core/widgets/bars/app_sidebar.dart';

class ChairmanDashboard extends StatelessWidget {
  ChairmanDashboard({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text('Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: const Center(child: Text('Dashboard Content')),
    );
  }
}
