import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kmb_app/features/admin/screens/application/services/application_response.dart';
import 'package:kmb_app/features/admin/screens/application/services/application_services.dart';
import 'package:kmb_app/features/admin/screens/application/widget/no_results_widget.dart';
import 'package:kmb_app/features/admin/widgets/status_filter.dart';
import 'package:provider/provider.dart';

// Internal/Project Imports
import 'package:kmb_app/features/admin/widgets/status_codes.dart';
import 'package:kmb_app/core/auth/user_role.dart';
import 'package:kmb_app/core/widgets/bars/app_sidebar.dart';
import 'package:kmb_app/features/admin/screens/application/widget/application_row.dart';
import 'package:kmb_app/features/admin/screens/application/model/application_model.dart';
import 'package:kmb_app/features/admin/screens/application/services/application_repository.dart';
import 'package:kmb_app/features/provider/auth_provider.dart';
import 'package:kmb_app/shared/search_box.dart';
import '../../widgets/table_shell.dart';

class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key});

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  late final ApplicationRepository _repository;

  // Logic Controllers
  final TextEditingController _searchController = TextEditingController();
  ApplicationFilter _filter = ApplicationFilter.newApp;
  String _searchQuery = "";

  late Future<ApplicationResponse> _futureApplications;
  int _currentPage = 1;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    _repository = ApplicationRepository(ApplicationService());

    _loadApplications(); // this now triggers setState properly
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadApplications() {
    _futureApplications = _repository.getApplications(
      page: _currentPage,
      limit: _limit,
    );
  }

  // void _refresh() {
  //   setState(() {
  //     _loadApplications();
  //   });
  // }
  void _refresh() {
    _loadApplications();
  }

  List<ApplicationModel> _getFilteredList(
    List<ApplicationModel> apps,
    UserRole role,
  ) {
    return apps.where((app) {
      final matchesStatus = _appMatchesFilterForRole(app, _filter, role);
      final searchableText = "${app.applicationNo} ${app.id}".toLowerCase();
      final matchesSearch = searchableText.contains(_searchQuery);
      return matchesStatus && matchesSearch;
    }).toList()..sort((a, b) => b.id.compareTo(a.id));
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentRole = authProvider.role;

    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: SearchBox(controller: _searchController),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh),
        ],
      ),
      body: currentRole == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<ApplicationResponse>(
              future: _futureApplications,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Something went wrong',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                final response = snapshot.data!;
                final allApplications = response.data;

                // print("Total apps: ${response.data.length}");
                final pagination = response.pagination;

                // _currentPage = pagination.page;

                // print("CURRENT PAGE: $_currentPage");
                // print("API PAGE: ${response.pagination.page}");

                final categoryApps = allApplications
                    .where(
                      (app) =>
                          _appMatchesFilterForRole(app, _filter, currentRole),
                    )
                    .toList();
                final searchResults = allApplications;

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // --- Glass-Neumorphic Status Chips ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: ApplicationFilter.values.map((filter) {
                          Color chipColor;
                          switch (filter) {
                            case ApplicationFilter.newApp:
                              chipColor = Colors.blueAccent;
                              break;
                            case ApplicationFilter.approved:
                              chipColor = Colors.greenAccent.shade700;
                              break;
                            case ApplicationFilter.rejected:
                              chipColor = Colors.redAccent.shade700;
                              break;
                            case ApplicationFilter.issued:
                              chipColor = Colors.orangeAccent.shade700;
                              break;
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: StatusChip(
                              label: _filterLabel(filter),
                              color: chipColor,
                              selected: _filter == filter,
                              onTap: () => setState(() => _filter = filter),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _buildBody(
                          categoryApps,
                          searchResults,
                          response,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  String _filterLabel(ApplicationFilter value) {
    switch (value) {
      case ApplicationFilter.newApp:
        return 'New';
      case ApplicationFilter.approved:
        return 'Approved';
      case ApplicationFilter.rejected:
        return 'Rejected';
      case ApplicationFilter.issued:
        return 'Issued';
    }
  }

  bool _appMatchesFilterForRole(
    ApplicationModel app,
    ApplicationFilter filter,
    UserRole role,
  ) {
    final status = app.currentStatus;

    if (role == UserRole.superAdmin) return app.matchesFilter(filter);
    if (filter == ApplicationFilter.rejected) {
      return StatusCode.isRejected(status);
    }
    if (filter == ApplicationFilter.issued) return app.permitIssued == 1;

    switch (role) {
      case UserRole.dealing:
        if (filter == ApplicationFilter.newApp) {
          return status == StatusCode.submitted;
        }
        if (filter == ApplicationFilter.approved) {
          return status == StatusCode.dealingApproved;
        }
        break;
      case UserRole.executive:
        if (filter == ApplicationFilter.newApp) {
          return status == StatusCode.dealingApproved;
        }
        if (filter == ApplicationFilter.approved) {
          return status == StatusCode.executiveApproved;
        }
        break;
      case UserRole.chairman:
        if (filter == ApplicationFilter.newApp) {
          return status == StatusCode.executiveApproved;
        }
        if (filter == ApplicationFilter.approved) {
          return status == StatusCode.chairmanApproved;
        }
        break;
      default:
        return false;
    }
    return false;
  }

  Widget _buildBody(
    List<ApplicationModel> categoryApps,
    List<ApplicationModel> searchResults,
    ApplicationResponse response,
  ) {
    if (searchResults.isEmpty) {
      return const Center(child: Text("No Applications Found"));
    }
    if (searchResults.isEmpty && _searchQuery.isNotEmpty) {
      return NoResultsWidget(
        query: _searchQuery,
        onClear: () => _searchController.clear(),
      );
    }
    // return ListView.builder(
    //   itemCount: response.data.length,
    //   itemBuilder: (_, i) => Text(response.data[i].applicationNo),
    // );
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: searchResults.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (_, index) =>
                ApplicationRow(kmbApplication: searchResults[index]),
          ),
        ),

        const SizedBox(height: 12),

        _buildPagination(response),
      ],
    );
  }

  Widget _buildPagination(ApplicationResponse response) {
    final pagination = response.pagination;

    final totalRecords = pagination.total;
    final totalPages = pagination.totalPages;
    final currentPage = _currentPage;

    final isFirstPage = currentPage <= 1;
    final isLastPage = currentPage >= totalPages;

    final startRecord = totalRecords == 0
        ? 0
        : ((currentPage - 1) * _limit) + 1;

    final endRecord = (currentPage * _limit) > totalRecords
        ? totalRecords
        : (currentPage * _limit);

    return Column(
      children: [
        Text(
          "Showing $startRecord–$endRecord of $totalRecords records",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                if (_currentPage > 1) {
                  setState(() {
                    _currentPage--;
                    _loadApplications();
                  });
                }
              },
            ),
            Text(
              "Page $currentPage of $totalPages",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                setState(() {
                  _currentPage++;
                  _loadApplications();
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}

// --- Glass-Neumorphic Chip Widget ---
class StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Color color;

  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final shadowColor = brightness == Brightness.dark
        ? Colors.black54
        : Colors.grey.shade300;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? color.withOpacity(0.6) : color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  offset: const Offset(4, 4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  offset: const Offset(-4, -4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(
                color: selected
                    ? color.withOpacity(0.8)
                    : color.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
