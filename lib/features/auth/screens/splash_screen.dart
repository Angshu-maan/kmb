import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:kmb_app/core/storage/secure_storage.dart';
import 'package:kmb_app/core/routes/role_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  String _version = '';
  bool _hasNetwork = true;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _initializeSplash();
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  Future<void> _initializeSplash() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (!mounted) return;

    setState(() {
      _version = packageInfo.version;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    // Check network
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _hasNetwork = false;
        _checking = false;
      });
      return;
    }

    // Check login
    final isLoggedIn = await SecureStorage.isLoggedIn();
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    if (!isLoggedIn) {
      context.go('/login');
      return;
    }
    final role = await SecureStorage.loadSession();
    if (!mounted) return;

    if (role == null) {
      await SecureStorage.clearAll();
      context.go('/login');
      return;
    }

    final session = await SecureStorage.loadSession();

    if (session != null) {
      final route = RoleRouter.homeRouteForRole(session.activeRole);
      context.goNamed(route);
    }

    // setState(() {
    //   _checking = false;
    // });

    // if (isLoggedIn) {
    //   context.go('/admin_dashboard');
    // } else {
    //   context.go('/login');
    // }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 112, 140, 214),
      body: SafeArea(
        child: Center(
          child: _checking
              ? _buildSplashContent()
              : _hasNetwork
              ? _buildSplashContent()
              : _buildNoNetwork(),
        ),
      ),
    );
  }

  Widget _buildSplashContent() {
    return FadeTransition(
      opacity: _animation,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Center content vertically
        children: [
          ScaleTransition(
            scale: _animation,
            child: Image.asset('assets/images/logo_black.png', width: 500, height: 300)),
          const SizedBox(height: 16),
          const Text(
            "KMB App",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            "Version: $_version",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          const Text(
            "Powered by QWERTCORP",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildNoNetwork() {
    return Column(
      mainAxisSize: MainAxisSize.min, // Center content vertically
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.signal_wifi_off, size: 60, color: Colors.red),
        const SizedBox(height: 16),
        const Text(
          "No Internet Connection",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          "Please check your network and try again.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _hasNetwork = true;
              _checking = true;
            });
            _initializeSplash();
          },
          child: const Text("Retry"),
        ),
      ],
    );
  }
}
