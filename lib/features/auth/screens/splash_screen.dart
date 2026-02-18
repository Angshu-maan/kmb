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

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _hasNetwork = false;
        _checking = false;
      });
      return;
    }

    final isLoggedIn = await SecureStorage.isLoggedIn();
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    if (!isLoggedIn) {
      context.go('/login');
      return;
    }

    final session = await SecureStorage.loadSession();

    if (!mounted) return;

    if (session == null) {
      await SecureStorage.clearAll();
      context.go('/login');
      return;
    }

    final route = RoleRouter.homeRouteForRole(session.activeRole);
    context.goNamed(route);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: _checking
              ? _buildSplashContent(theme)
              : _hasNetwork
              ? _buildSplashContent(theme)
              : _buildNoNetwork(theme),
        ),
      ),
    );
  }

  Widget _buildSplashContent(ThemeData theme) {
    return FadeTransition(
      opacity: _animation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _animation,
            child: Image.asset(
              theme.brightness == Brightness.dark
                  ? 'assets/images/logo_white.png'
                  : 'assets/images/logo_black.png',
              width: 500,
              height: 300,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            "KMB App",
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onBackground,
            ),
          ),

          const SizedBox(height: 20),

          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "Version: $_version",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Powered by QWERTCORP",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoNetwork(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.signal_wifi_off, size: 60, color: theme.colorScheme.error),
        const SizedBox(height: 16),

        Text(
          "No Internet Connection",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onBackground,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "Please check your network and try again.",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onBackground.withOpacity(0.7),
          ),
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
