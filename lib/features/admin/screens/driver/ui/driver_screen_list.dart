import 'package:flutter/material.dart';
import 'package:kmb_app/core/widgets/bars/app_sidebar.dart';
import 'package:kmb_app/features/admin/widgets/status_codes.dart';
import 'package:kmb_app/features/admin/widgets/status_filter.dart';
import 'package:kmb_app/shared/search_box.dart';
import '../../../widgets/table_shell.dart';
import 'widget/driver_row.dart';
import '../model/driver_model.dart';
import '../data/driver_repository.dart';

class DriverScreenList extends StatefulWidget {
  const DriverScreenList({super.key});
  @override
  State<DriverScreenList> createState() => _DriverScreenListState();
}

class _DriverScreenListState extends State<DriverScreenList> {
  StatusFilter _filter = StatusFilter.active;
  List<DriverModel> _applyFilter(List<DriverModel> drivers) {
    final filtered = drivers.where((driver) {
      switch (_filter) {
        case StatusFilter.active:
          return driver.active == StatusCode.active;

        case StatusFilter.inactive:
          return driver.active == StatusCode.inactive;
      }
    }).toList();

    filtered.sort((a, b) => b.id.compareTo(a.id));
    return filtered;
  }

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
          final filteredDrivers = _applyFilter(drivers);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                StatusFilterToggle<StatusFilter>(
                  selected: _filter,
                  values: StatusFilter.values,
                  onChanged: (value) {
                    setState(() => _filter = value);
                  },
                  labelBuilder: (value) {
                    switch (value) {
                      case StatusFilter.active:
                        return 'Active';
                      case StatusFilter.inactive:
                        return 'Inactive';
                    }
                  },
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: filteredDrivers.isEmpty
                      ? const Center(child: Text('No drivers found'))
                      : SimpleTableShell(
                          itemCount: filteredDrivers.length,
                          columns: const [
                            TableColumn('Name', flex: 2),
                            TableColumn('Phone', flex: 2),
                            TableColumn('Status'),
                            TableColumn('Actions'),
                          ],
                          body: ListView.separated(
                            itemCount: filteredDrivers.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (_, i) =>
                                DriverRow(driver: filteredDrivers[i]),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
