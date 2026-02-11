import 'package:flutter/material.dart';
import 'package:kmb_app/core/utils/document_helper.dart';
import 'package:kmb_app/features/admin/screens/owner/model/owner_model.dart';

import 'package:kmb_app/features/admin/widgets/image_placeholder.dart';
import 'package:kmb_app/features/admin/widgets/details_row.dart';
import 'package:kmb_app/features/admin/widgets/detail_field.dart';

class OwnerDetailsScreen extends StatelessWidget {
  final OwnerModel owner;

  const OwnerDetailsScreen({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Owner Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Owner Inforamtion',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            //image
            DocumentImage(
              category: DocCategory.owner,
              type: DocType.passportPhoto,
              id: owner.id,
            ),
            const SizedBox(height: 24),
            DetailsRow(
              left: DetailField(
                label: 'OWNER\'S NAME',
                value: owner.ownerName.isNotEmpty == true
                    ? owner.ownerName
                    : "Not available",
              ),
              right: DetailField(
                label: 'OWNER\'S PHONE',
                value: owner.ownerPhone.isNotEmpty == true
                    ? owner.ownerPhone
                    : "Not available",
              ),
            ),

            const SizedBox(height: 16),
            DetailsRow(
              left: DetailField(
                label: "PAN",
                value: owner.ownerPan?.isNotEmpty == true
                    ? owner.ownerPan!
                    : "Not available",
                showViewIcon: true,
                onView: () {},
              ),
              right: DetailField(
                label: "VOTER ID",
                value: owner.ownerVoter?.isNotEmpty == true
                    ? owner.ownerVoter!
                    : "Not available",
                showViewIcon: true,
                onView: () {},
              ),
            ),

            const SizedBox(height: 16),

            DetailsRow(
              left: DetailField(
                label: "AADHAAR",
                value: owner.ownerAadhar?.isNotEmpty == true
                    ? owner.ownerAadhar!
                    : "Not available",
                showViewIcon: true,
                onView: () {},
              ),
              right: DetailField(
                label: "ADDRESS",
                value: owner.ownerAddress?.isNotEmpty == true
                    ? owner.ownerAddress!.formatted
                    : " Not available",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
