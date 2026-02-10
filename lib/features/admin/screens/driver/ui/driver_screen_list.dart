import 'package:flutter/material.dart';
import 'package:kmb_app/core/widgets/bars/app_sidebar.dart';
import '../../../widgets/table_shell.dart';
import 'widget/driver_row.dart';
import '../model/driver_model.dart';
import '../data/driver_repository.dart';

class DriverScreenList extends StatelessWidget {
  const DriverScreenList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drivers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {},
          ),
        ],
      ),
      drawer: const AppSidebar(),
      body: FutureBuilder<List<DriverModel>>(
        future: DriverRepository().getDrivers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(color: Colors.red.shade400),
              ),
            );
          }

          final drivers = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SimpleTableShell(
              itemCount: drivers.length,
              columns: const [
                TableColumn('Name', flex: 2),
                TableColumn('Phone', flex: 2),
                TableColumn('Status'),
                TableColumn('Actions'),
              ],
              body: ListView.separated(
                itemCount: drivers.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => DriverRow(driver: drivers[i]),
              ),
            ),
          );
        },
      ),
    );
  }
}
