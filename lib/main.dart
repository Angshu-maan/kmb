

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kmb_app/core/storage/secure_storage.dart';
import 'package:kmb_app/features/auth/screens/otp_screen.dart';
import 'package:provider/provider.dart';

import 'package:kmb_app/features/provider/auth_provider.dart';
import 'package:kmb_app/core/auth/session_manager.dart';
import 'package:kmb_app/core/routes/app_router.dart';
import 'package:kmb_app/core/global/globals.dart';


void main() async {
  // debugPaintSizeEnabled =true;
  WidgetsFlutterBinding.ensureInitialized();
  SecureStorage();
  // final loggedIn = await SecureStorage.isLoggedIn();
  // AuthState.isLoggedIn.value = loggedIn;

  // final authProvider = AuthProvider();
  await SessionManager.load(); // loads SecureStorage/session
  

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider()..loadSession(),
        ),
      ],
    
      child:  const MyApp(),
    ),
  );


  FlutterNativeSplash.remove();
}
class MyApp extends StatelessWidget {

 const  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final  auth = context.watch<AuthProvider>();
    return MaterialApp.router(
      title: 'Kokrajhar Municipal Board',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter(auth),

      theme: ThemeData(primarySwatch: Colors.blue),
     scaffoldMessengerKey: rootScaffoldMessengerKey,
     
    );
  }

}


