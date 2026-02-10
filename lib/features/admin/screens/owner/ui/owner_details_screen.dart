import 'package:flutter/material.dart';
import '../model/owner_model.dart';

class OwnerDetailsScreen extends StatelessWidget {
  final OwnerModel owner;

  const OwnerDetailsScreen({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner details'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            const Text(
              'OWNER INFORMATION',
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
          _detail('OWNER\'S NAME', owner.ownerName ?? '-'),
          _detail('OWNER\'S PHONE', owner.ownerPhone),
        ),
        const SizedBox(height: 16),
        _row(
          _documentDetail('OWNER\'S PAN', owner.ownerPan),
          _documentDetail('OWNER\'S VOTER', owner.ownerVoter),
        ),
        const SizedBox(height: 16),
        _row(
          _documentDetail('OWNER\'S AADHAAR', owner.ownerAadhar),
          _detail(
            'OWNER\'S ADDRESS',
            owner.ownerAddress == null || owner.ownerAddress!.isEmpty
                ? 'Address not available'
                : owner.ownerAddress!.formatted,
          ),
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
