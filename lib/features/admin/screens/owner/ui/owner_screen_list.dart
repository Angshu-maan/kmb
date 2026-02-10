import 'package:flutter/material.dart';
import 'package:kmb_app/core/widgets/bars/app_sidebar.dart';
import '../../../widgets/table_shell.dart';
import 'widgets/owner_row.dart';
import '../model/owner_model.dart';
import '../data/owner_repository.dart';

class OwnerScreen extends StatelessWidget {
  const OwnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owners'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {},
          ),
        ],
      ),
      drawer: const AppSidebar(),
      body: FutureBuilder<List<OwnerModel>>(
        future: OwnerRepository().getOwners(),
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

          final owners = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SimpleTableShell(
              itemCount: owners.length,
              columns: const [
                TableColumn('Name', flex: 2),
                TableColumn('Phone', flex: 2),
                TableColumn('Status'),
                TableColumn('Actions'),
              ],
              body: ListView.separated(
                itemCount: owners.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => OwnerRow(owner: owners[i]),
              ),
            ),
          );
        },
      ),
    );
  }
}
