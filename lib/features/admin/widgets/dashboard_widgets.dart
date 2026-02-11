import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/dashboard_model.dart';
import 'dashboard_card.dart';

class DashboardWidgets extends StatelessWidget {
  const DashboardWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DashboardModel> dashboardItems = [
      DashboardModel(
        title: "Total Owners",
        value: "120+",
        icon: Icons.person,
        color: Colors.blue,
        onTap: () => context.goNamed('owner_list'),
      ),
      DashboardModel(
        title: "Total Rikshaws",
        value: "350+",
        icon: Icons.electric_rickshaw,
        color: Colors.green,
      ),
      DashboardModel(
        title: "New Permit Applications",
        value: "18",
        icon: Icons.assignment_add,
        color: Colors.orange,
        onTap: () {
          context.goNamed("application_list");
        },
      ),
      DashboardModel(
        title: "Applications for Changes",
        value: "1246",
        icon: Icons.edit_document,
        color: Colors.green,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: dashboardItems.length,
      itemBuilder: (context, index) {
        return DashboardCard(model: dashboardItems[index]);
      },
    );
  }
}
