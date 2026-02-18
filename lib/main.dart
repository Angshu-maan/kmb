import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:kmb_app/core/storage/secure_storage.dart';
// import 'package:kmb_app/features/auth/screens/otp_screen.dart';
import 'package:kmb_app/features/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import 'package:kmb_app/features/provider/auth_provider.dart';
import 'package:kmb_app/core/auth/session_manager.dart';
import 'package:kmb_app/core/routes/app_router.dart';
import 'package:kmb_app/core/global/globals.dart';

void main() async {
  // debugPaintSizeEnabled = true;
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

        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],

      child: const MyApp(),
    ),
  );

  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    final auth = context.read<AuthProvider>();

    _router = appRouter(auth); // Create only once
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp.router(
      title: 'Kokrajhar Municipal Board',
      debugShowCheckedModeBanner: false,
      routerConfig: _router, //  Use stored router

      themeMode: themeProvider.themeMode,

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade50,
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          surface: Color(0xFF1E1E1E),
        ),
      ),

      // theme: ThemeData(primarySwatch: Colors.blue),
      scaffoldMessengerKey: rootScaffoldMessengerKey,
    );
  }
}
