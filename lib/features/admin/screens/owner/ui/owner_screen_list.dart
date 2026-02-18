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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: SearchBox(controller: SearchController()),
      ),

      drawer: const AppSidebar(),

      body: FutureBuilder<List<OwnerModel>>(
        future: OwnerRepository().getOwners(),
        builder: (context, snapshot) {
          /// -------- LOADING --------
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: colors.primary),
            );
          }

          /// -------- ERROR --------
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(color: colors.error, fontSize: 16),
              ),
            );
          }

          final owners = snapshot.data ?? [];
          final filteredOwners = _applyFilter(owners);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// -------- FILTER TOGGLE --------
                StatusFilterToggle(
                  activeLabel: 'Active',
                  inactiveLabel: 'Inactive',
                  selected: _filter,
                  onChanged: (value) {
                    setState(() => _filter = value);
                  },
                ),

                const SizedBox(height: 12),

                /// -------- TABLE --------
                Expanded(
                  child: filteredOwners.isEmpty
                      ? Center(
                          child: Text(
                            'No Owners found',
                            style: TextStyle(
                              color: Theme.of(context).cardColor,
                              fontSize: 15,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: theme.brightness == Brightness.light
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: SimpleTableShell(
                            itemCount: filteredOwners.length,
                            columns: const [
                              TableColumn('Name', flex: 2),
                              TableColumn('Phone', flex: 2),
                              TableColumn('Status'),
                              TableColumn('Actions'),
                            ],
                            body: ListView.separated(
                              itemCount: filteredOwners.length,
                              separatorBuilder: (_, __) => Divider(
                                height: 1,
                                color: colors.outline.withOpacity(0.2),
                              ),
                              itemBuilder: (_, i) =>
                                  OwnerRow(owner: filteredOwners[i]),
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
