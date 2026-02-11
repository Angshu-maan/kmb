import 'package:flutter/material.dart';
import 'package:kmb_app/core/widgets/bars/app_sidebar.dart';
import 'package:kmb_app/features/admin/screens/application/widget/application_row.dart';
import 'package:kmb_app/features/admin/screens/application/model/application_model.dart';
import 'package:kmb_app/features/admin/screens/application/services/application_repository.dart';
import 'package:kmb_app/features/admin/widgets/status_codes.dart';
import 'package:kmb_app/features/admin/widgets/status_filter.dart';
import 'package:kmb_app/shared/search_box.dart';
import '../../widgets/table_shell.dart';

class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key});

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  StatusFilter _filter = StatusFilter.active;
  List<ApplicationModel> _applyFilter(List<ApplicationModel> applications) {
    final filtered = applications.where((app) {
      switch (_filter) {
        case StatusFilter.active:
          return app.applicationStatus == StatusCode.submitted ||
              app.applicationStatus == StatusCode.dealingApproved ||
              app.applicationStatus == StatusCode.eoApproved ||
              app.applicationStatus == StatusCode.chairmanApproved;

        case StatusFilter.inactive:
          return app.applicationStatus == StatusCode.dealingReject ||
              app.applicationStatus == StatusCode.notSubmitted ||
              app.applicationStatus == StatusCode.eoReject ||
              app.applicationStatus == StatusCode.chairmanRejected;
      }
    }).toList();

    filtered.sort((a, b) => b.id.compareTo(a.id));
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: SearchBox(controller: SearchController())),
      drawer: const AppSidebar(),
      body: FutureBuilder<List<ApplicationModel>>(
        future: ApplicationRepository().getApplications(),
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

          final applications = snapshot.data ?? [];
          final filteredApplications = _applyFilter(applications);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                StatusFilterToggle(
                  activeLabel: 'Approved',
                  inactiveLabel: 'Rejected',
                  selected: _filter,
                  onChanged: (value) {
                    setState(() => _filter = value);
                  },
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: filteredApplications.isEmpty
                      ? const Center(child: Text('No Application found'))
                      : SimpleTableShell(
                          itemCount: filteredApplications.length,
                          columns: const [
                            TableColumn('Application No', flex: 2),
                            TableColumn('Status', flex: 3),
                            TableColumn('Actions', flex: 0),
                          ],
                          body: ListView.separated(
                            itemCount: filteredApplications.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (_, i) => ApplicationRow(
                              kmbApplication: filteredApplications[i],
                            ),
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
