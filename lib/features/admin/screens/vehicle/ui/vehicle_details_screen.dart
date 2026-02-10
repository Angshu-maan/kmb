import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:kmb_app/features/admin/screens/vehicle/model/vehicle_model.dart';

String formatDate(DateTime? date) {
  if (date == null) return '-';
  return DateFormat('yyyy-MM-dd').format(date);
}


class VehicleDetailsScreen extends StatelessWidget {
  final VehicleModel vehicle;

  const VehicleDetailsScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            const Text(
              'VEHICLE INFORMATION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),

            // Photo placeholder
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'No Photo Available',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Details grid
            _detailsGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _detailsGrid(BuildContext context) {
    return Column(
      children: [
        _row(
          _detail('vehicle\'S NAME', vehicle.rcNo ?? 'Not Available'),
          _detail('vehicle\'S Issue Date',formatDate(vehicle.rcIssueDate) ),
        ),
        const SizedBox(height: 16),
        _row(
          _documentDetail('vehicle\'S RC Expiry Date', formatDate(vehicle.rcExpiryDate) ),
          _documentDetail('vehicle\'S Insurance No', vehicle.insuranceNo ?? 'Not Available'),
        ),
        const SizedBox(height: 16),
        _row(
          _documentDetail('vehicle\'S Insurance Issue Date', formatDate(vehicle.insuranceIssueDate) ),
          _documentDetail('Vehicle\'S Insurance Expiry Date', formatDate(vehicle.insuranceExpiryDate))
        ),
      ],
    );
  }

  Widget _row(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }

  Widget _detail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _documentDetail(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              value ?? '-',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            if (value != null)
              InkWell(
                onTap: () {},
                child: const Icon(Icons.visibility, size: 18),
              ),
          ],
        ),
      ],
    );
  }
}
