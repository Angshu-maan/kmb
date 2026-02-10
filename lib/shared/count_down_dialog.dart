// import 'package:flutter/material.dart';
// import 'package:kmb_app/core/storage/secure_storage.dart';
// import 'package:kmb_app/features/provider/auth_provider.dart';
// import 'package:provider/provider.dart';

// class CountDownDialog extends StatelessWidget {
//   const CountDownDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();

//     if (!auth.showCountdown || auth.dialogShown) {
//       return const SizedBox.shrink();
//     }

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       auth.markDialogShown();

//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) => AlertDialog(
//           title: const Text("Session Expiring"),
//           content: Text(
//             "You will be logged out in ${auth.secondsLeft} seconds",
//           ),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 await SecureStorage.refreshTimestamp();
//                 auth.stopCountdown();
//                 Navigator.of(context).pop();
//               },
//               child: const Text("Stay Logged In"),
//             ),
//           ],
//         ),
//       );
//     });

//     return const SizedBox.shrink();
//   }
// }
