import 'package:flutter/material.dart';

class SimpleTableShell extends StatelessWidget {
  final List<TableColumn> columns;
  final Widget body;
  final int itemCount;

  const SimpleTableShell({
    super.key,

    required this.columns,
    required this.body,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,

        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: columns
                  .map(
                    (c) => Expanded(
                      flex: c.flex,
                      child: Text(
                        c.label,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: itemCount == 0
                ? ListView(children: [_EmptyTableRow(columns: columns)])
                : body,
          ),
        ],
      ),
    );
  }
}

class _EmptyTableRow extends StatelessWidget {
  final List<TableColumn> columns;

  const _EmptyTableRow({required this.columns});

  @override
  Widget build(BuildContext context) {
    final totalFlex = columns.fold<int>(0, (sum, c) => sum + c.flex);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Expanded(
            flex: totalFlex,
            child: Text(
              'No data found',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class TableColumn {
  final String label;
  final int flex;

  const TableColumn(this.label, {this.flex = 1});
}
