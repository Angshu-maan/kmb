import 'package:flutter/material.dart';
import 'package:kmb_app/core/widgets/bars/app_sidebar.dart';
import 'package:kmb_app/features/admin/screens/application/widget/application_row.dart';
import 'package:kmb_app/features/admin/screens/application/model/application_model.dart';
import 'package:kmb_app/features/admin/screens/application/services/application_repository.dart';
import '../../widgets/table_shell.dart';

class ApplicationScreen extends StatelessWidget {
  const ApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {},
          ),
        ],
      ),
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

          final application = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SimpleTableShell(
              itemCount: application.length,
              columns: const [
                TableColumn('Name', flex: 2),
                TableColumn('Phone', flex: 2),
                TableColumn('Status'),
                TableColumn('Actions'),
              ],
              body: ListView.separated(
                itemCount: application.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => ApplicationRow(kmbApplication: application[i]),
              ),
            ),
          );
        },
      ),
    );
  }
}
