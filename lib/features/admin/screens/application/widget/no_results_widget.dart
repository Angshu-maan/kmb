import 'package:flutter/material.dart';

class NoResultsWidget extends StatelessWidget {
  final String query;
  final VoidCallback onClear;
  final bool isSearch; // New flag

  const NoResultsWidget({
    super.key,
    required this.query,
    required this.onClear,
    this.isSearch = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearch ? Icons.search_off_rounded : Icons.inbox_rounded,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            isSearch ? 'No matches found' : 'No $query Applications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSearch
                ? 'Try searching for a different ID or number.'
                : 'There are currently no applications in this section.',
            style: TextStyle(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: onClear,
            icon: Icon(isSearch ? Icons.close : Icons.refresh, size: 18),
            label: Text(isSearch ? 'Clear Search' : 'Refresh Now'),
          ),
        ],
      ),
    );
  }
}
