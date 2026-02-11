import 'package:flutter/material.dart';
import 'package:kmb_app/core/utils/document_helper.dart';

import 'package:kmb_app/features/admin/widgets/image_placeholder.dart';
import 'package:kmb_app/features/admin/widgets/details_row.dart';
import 'package:kmb_app/features/admin/widgets/detail_field.dart';
import '../model/driver_model.dart';

class DriverDetailsScreen extends StatelessWidget {
  final DriverModel driver;

  const DriverDetailsScreen({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Driver Inforamtion',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            //image
            DocumentImage(
              category: DocCategory.driver,
              type: DocType.passportPhoto,
              id: driver.id,
            ),
            const SizedBox(height: 24),
            DetailsRow(
              left: DetailField(
                label: 'DRIVER\'S NAME',
                value: driver.driverName.isNotEmpty == true
                    ? driver.driverName
                    : "Not available",
              ),
              right: DetailField(
                label: "DRIVER'S PHONE",
                value: driver.driverContact?.isNotEmpty == true
                    ? driver.driverContact!
                    : "Not available",
              ),
            ),

            const SizedBox(height: 16),
            DetailsRow(
              left: DetailField(
                label: "PAN",
                value: driver.driverPan?.isNotEmpty == true
                    ? driver.driverPan!
                    : "Not available",
                showViewIcon: true,
                onView: () {},
              ),
              right: DetailField(
                label: "VOTER ID",
                value: driver.driverVoter?.isNotEmpty == true
                    ? driver.driverVoter!
                    : "Not available",
                showViewIcon: true,
                onView: () {},
              ),
            ),

            const SizedBox(height: 16),

            DetailsRow(
              left: DetailField(
                label: "AADHAAR",
                value: driver.driverAadhar?.isNotEmpty == true
                    ? driver.driverAadhar!
                    : "Not available",
                showViewIcon: true,
                onView: () {},
              ),
              right: DetailField(
                label: "ADDRESS",
                value: driver.driverAddress?.isNotEmpty == true
                    ? driver.driverAddress!.formatted
                    : " Not available",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//3rd-----------------------------

// class DriverDetailsScreen extends StatelessWidget {
//   const DriverDetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Driver Details')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'DRIVER INFORMATION',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 1,
//               ),
//             ),
//             const SizedBox(height: 12),

//             const ImageBox(),

//             const SizedBox(height: 24),

//             DetailsRow(
//               left: const DetailField(
//                 label: "DRIVER'S NAME",
//                 value: "Ramesh Kumar",
//               ),
//               right: const DetailField(
//                 label: "DRIVER'S PHONE",
//                 value: "9876543210",
//               ),
//             ),

//             const SizedBox(height: 16),

//             DetailsRow(
//               left: DetailField(
//                 label: "PAN",
//                 value: "ABCDE1234F",
//                 showViewIcon: true,
//                 onView: () {},
//               ),
//               right: DetailField(
//                 label: "VOTER ID",
//                 value: "VOTER123",
//                 showViewIcon: true,
//                 onView: () {},
//               ),
//             ),

//             const SizedBox(height: 16),

//             DetailsRow(
//               left: DetailField(
//                 label: "AADHAAR",
//                 value: "1234 5678 9012",
//                 showViewIcon: true,
//                 onView: () {},
//               ),
//               right: const DetailField(
//                 label: "ADDRESS",
//                 value: "Guwahati, Assam",
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
