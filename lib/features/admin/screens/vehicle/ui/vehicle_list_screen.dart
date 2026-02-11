import 'package:flutter/material.dart';
import 'package:kmb_app/core/widgets/bars/app_sidebar.dart';
import 'package:kmb_app/features/admin/screens/vehicle/data/vehicle_repository.dart';
import 'package:kmb_app/features/admin/screens/vehicle/model/vehicle_model.dart';
import 'package:kmb_app/features/admin/screens/vehicle/ui/widgets/vehicle_row.dart';
import 'package:kmb_app/shared/search_box.dart';
import '../../../widgets/table_shell.dart';

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBox(
          controller: SearchController(),

          // onChanged: filteredOnwers,
          // hintText: "Type application ID or Name",
        ),
      ),
      drawer: const AppSidebar(),
      body: FutureBuilder<List<VehicleModel>>(
        future: VehicleRepository().getVehicle(),
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

          final vehicles = snapshot.data ?? [];
          print(vehicles.length);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SimpleTableShell(
              itemCount: vehicles.length,
              columns: const [
                TableColumn('Regd No', flex: 2),

                // TableColumn('Status', flex: 2),
                TableColumn('Actions', flex: 0),
              ],
              body: ListView.separated(
                itemCount: vehicles.length,

                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => VehicleRow(vehicle: vehicles[i]),
              ),
            ),
          );
        },
      ),
    );
  }
}
