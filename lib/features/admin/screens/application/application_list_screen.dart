import 'package:flutter/material.dart';
import 'package:kmb_app/core/widgets/bars/app_sidebar.dart';
import 'package:kmb_app/features/admin/screens/application/applictaion_details_screen.dart';
import 'package:kmb_app/features/admin/screens/application/model/application_model.dart';
import 'package:kmb_app/features/admin/screens/application/services/application_repository.dart';
import 'package:kmb_app/features/admin/widgets/status_codes.dart';
import 'package:kmb_app/features/admin/widgets/status_filter.dart';
import 'package:kmb_app/shared/search_box.dart';

class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key});

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  StatusFilter _filter = StatusFilter.active;

  late Future<List<ApplicationModel>> _futureApplications;

  @override
  void initState() {
    super.initState();
    _futureApplications = ApplicationRepository().getApplications();
  }

  List<ApplicationModel> _applyFilter(List<ApplicationModel> applications) {
    final filtered = applications.where((app) {
      switch (_filter) {
        case StatusFilter.active:
          return [
            StatusCode.submitted,
            StatusCode.dealingApproved,
            StatusCode.eoApproved,
            StatusCode.chairmanApproved
          ].contains(app.applicationStatus);

        case StatusFilter.inactive:
          return [
            StatusCode.dealingReject,
            StatusCode.notSubmitted,
            StatusCode.eoReject,
            StatusCode.chairmanRejected
          ].contains(app.applicationStatus);
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
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: SearchBox(controller: SearchController()),
      ),
      drawer: const AppSidebar(),
      body: FutureBuilder<List<ApplicationModel>>(
        future: _futureApplications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: colors.primary,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(color: colors.error),
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
                  onChanged: (value) => setState(() => _filter = value),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: filteredApplications.isEmpty
                      ? Center(
                          child: Text(
                            'No Application Found',
                            style: TextStyle(
                              color: colors.onSurface.withOpacity(0.6),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredApplications.length,
                          itemBuilder: (context, index) {
                            final app = filteredApplications[index];
                            return ApplicationCard(
                              application: app,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ApplicationDetailsScreen(
                                      applicationModel: app,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
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

class ApplicationCard extends StatefulWidget {
  final ApplicationModel application;
  final VoidCallback onTap;

  const ApplicationCard({
    required this.application,
    required this.onTap,
    super.key,
  });

  @override
  State<ApplicationCard> createState() => _ApplicationCardState();
}

class _ApplicationCardState extends State<ApplicationCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: _hover
            ? colors.primaryContainer
            : colors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.08),
            blurRadius: _hover ? 14 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: widget.onTap,
        onHover: (hovering) => setState(() => _hover = hovering),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.application.applicationNo,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Status: ${_statusLabel(widget.application.applicationStatus)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _statusColor(
                            widget.application.applicationStatus, colors),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  elevation: _hover ? 4 : 0,
                ),
                onPressed: widget.onTap,
                child: const Text(
                  'View',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(int status) {
    switch (status) {
      case 0:
        return "Pending";
      case 1:
        return "Approved";
      case 2:
        return "Rejected";
      default:
        return "Unknown";
    }
  }

  Color _statusColor(int status, ColorScheme colors) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.green;
      case 2:
        return colors.error;
      default:
        return colors.outline;
    }
  }
}
