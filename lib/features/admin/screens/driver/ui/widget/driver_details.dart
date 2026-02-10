// import 'package:flutter/material.dart';

// class DriverDetails extends StatelessWidget {
// final Row row;
// final  Widget widgetdetails;



//   const DriverDetails({super.key,required this.row,required this.widgetdetails});



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       appBar: AppBar(
//         title: const Text('Driver Details'),
//         leading: const BackButton(),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Section title
//             const Text(
//               'DRIVER INFORMATION',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 1,
//                 color: Color.fromARGB(255, 78, 78, 78),
//               ),
//             ),
//             const SizedBox(height: 12),

//             Container(
//               height: 140,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Color.fromARGB(255, 78, 78, 78),
//                   style: BorderStyle.solid,
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   Icon(
//                     Icons.image_outlined,
//                     size: 40,
//                     color: Color.fromARGB(255, 78, 78, 78),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'No Photo Available',
//                     style: TextStyle(color: Color.fromARGB(255, 78, 78, 78)),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 24),

//             _detailsGrid(context),
//           ],
//         ),
//       ),
//     );
//     ;
//   }

//   Widget _detailsGrid(BuildContext context) {
//     return Column(
//       children: [
//         _row(
//           // _detail('DRIVER\'S NAME', driver.driverName),
//           // _detail('DRIVER\'S PHONE', driver.driverContact ?? 'Not Available'),
//           _detail('DRIVER\'S NAME', ''),
//           _detail('DRIVER\'S PHONE', ''),
//         ),
//         const SizedBox(height: 16),
//         _row(
//           // _documentDetail('DRIVER\'S PAN', driver.driverPan ?? 'Not Available'),
//           _documentDetail('DRIVER\'S PAN', ''),
//           _documentDetail(
//             'DRIVER\'S VOTER',
//             '',
//             // driver.driverVoter ?? 'Not Available',
//           ),
//         ),
//         const SizedBox(height: 16),
//         _row(
//           _documentDetail(
//             'DRIVER\'S AADHAAR',
//             '',
//             // driver.driverAadhar ?? 'Not Available',
//           ),
//           _detail(
//             'DRIVER\'S ADDRESS',
//             '',
//             // driver.driverAddress == null || driver.driverAddress!.isEmpty
//             //     ? 'Address not available'
//             //     : driver.driverAddress!.formatted,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _row(Widget left, Widget right) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(child: left),
//         const SizedBox(width: 16),
//         Expanded(child: right),
//       ],
//     );
//   }

//   Widget _detail(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w600,
//             color: Color.fromARGB(255, 78, 78, 78),
//           ),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           value,
//           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//         ),
//       ],
//     );
//   }

//   Widget _documentDetail(String label, String? value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w600,
//             color: Color.fromARGB(255, 78, 78, 78),
//           ),
//         ),
//         const SizedBox(height: 6),
//         Row(
//           children: [
//             Text(
//               value ?? '-',
//               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(width: 8),
//             if (value != null)
//               InkWell(
//                 onTap: () {},
//                 child: const Icon(Icons.visibility, size: 18),
//               ),
//           ],
//         ),
//       ],
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DriverDetails extends StatelessWidget {
  const DriverDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}