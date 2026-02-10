import 'package:flutter/material.dart';

import 'package:kmb_app/features/admin/screens/driver/ui/widget/driver_details_image_placeholder.dart';
import 'package:kmb_app/features/admin/screens/driver/ui/widget/driver_details_row.dart';
import 'package:kmb_app/features/admin/screens/driver/ui/widget/drivers_detail_field.dart';
import '../model/driver_model.dart';

class DriverDetailsScreen extends StatelessWidget {
  final DriverModel driver;


  // fin

  const DriverDetailsScreen({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Details'),
      ),
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
            const SizedBox(height: 12,),
            const DriverDetailsImagePlaceholder(),
            const SizedBox(height: 24,),
                        DriverDetailsRow(
              left:  DriversDetailField(
                label: 'DRIVER\'S NAME',
                value: driver.driverName,
              ),
              right:  DriversDetailField(
                label: "DRIVER'S PHONE",
                value: driver.driverContact.toString(),
              ),
            ),

            const SizedBox(height: 16,),
                        DriverDetailsRow(
              left: DriversDetailField(
                label: "PAN",
                value: driver.driverPan.toString(),
                showViewIcon: true,
                onView: () {},
              ),
              right: DriversDetailField(
                label: "VOTER ID",
                value: driver.driverVoter.toString(),
                showViewIcon: true,
                onView: () {},
              ),
            ),

                        const SizedBox(height: 16),

            DriverDetailsRow(
              left: DriversDetailField(
                label: "AADHAAR",
                value: "1234 5678 9012",
                showViewIcon: true,
                onView: () {},
              ),
              right: const DriversDetailField(
                label: "ADDRESS",
                value: "Guwahati, Assam",
              ),
            ),


          ],
        ),
      ),
      
    );
  }
}








