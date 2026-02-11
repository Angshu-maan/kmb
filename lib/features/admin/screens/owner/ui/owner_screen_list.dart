import 'package:flutter/material.dart';
import 'package:kmb_app/core/widgets/bars/app_sidebar.dart';
import 'package:kmb_app/features/admin/screens/owner/data/owner_repository.dart';
import 'package:kmb_app/features/admin/screens/owner/model/owner_model.dart';
import 'package:kmb_app/features/admin/screens/owner/ui/widgets/owner_row.dart';
import 'package:kmb_app/features/admin/widgets/status_codes.dart';
import 'package:kmb_app/features/admin/widgets/status_filter.dart';
import 'package:kmb_app/features/admin/widgets/table_shell.dart';
import 'package:kmb_app/shared/search_box.dart';

class OwnerScreenList extends StatefulWidget {
  const OwnerScreenList({super.key});
  @override
  State<OwnerScreenList> createState() => _OwnerScreenListState();
}

class _OwnerScreenListState extends State<OwnerScreenList> {
  StatusFilter _filter = StatusFilter.active;
  List<OwnerModel> _applyFilter(List<OwnerModel> owners) {
    final filtered = owners.where((owner) {
      switch (_filter) {
        case StatusFilter.active:
          return owner.active == StatusCode.active;

        case StatusFilter.inactive:
          return owner.active == StatusCode.inactive;
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
          final filteredOnwers = _applyFilter(owners);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                StatusFilterToggle(
                  activeLabel: 'Active',
                  inactiveLabel: 'Inacive',
                  selected: _filter,
                  onChanged: (value) {
                    setState(() => _filter = value);
                  },
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: filteredOnwers.isEmpty
                      ? const Center(child: Text('No Owners found'))
                      : SimpleTableShell(
                          itemCount: filteredOnwers.length,
                          columns: const [
                            TableColumn('Name', flex: 2),
                            TableColumn('Phone', flex: 2),
                            TableColumn('Status'),
                            TableColumn('Actions'),
                          ],
                          body: ListView.separated(
                            itemCount: filteredOnwers.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (_, i) =>
                                OwnerRow(owner: filteredOnwers[i]),
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
