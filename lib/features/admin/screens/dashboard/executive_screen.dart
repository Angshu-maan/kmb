import 'package:flutter/material.dart';
// import 'package:kmb_app/features/admin/widgets/dashboard_widgets.dart';
import '../../../../core/widgets/bars/app_sidebar.dart';

class Executivedashboardpage extends StatelessWidget {
  Executivedashboardpage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text('Excutive'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: const Center(child: Text('Dashboard Content'))
    );
  }
}
