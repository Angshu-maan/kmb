import 'package:flutter/material.dart';
import 'package:kmb_app/core/auth/user_role.dart';
import 'package:kmb_app/shared/day_night_toggle.dart';
import 'package:provider/provider.dart';
import 'package:kmb_app/features/admin/widgets/dashboard_widgets.dart';
import 'package:kmb_app/shared/back_button_handler.dart';
import '../../../../core/widgets/bars/app_sidebar.dart';
import '../../../../core/widgets/bars/app_bottom_bar.dart';
import '../../../provider/auth_provider.dart';

class ChairmanDashboard extends StatefulWidget {
  const ChairmanDashboard({super.key});

  @override
  State<ChairmanDashboard> createState() => _ChairmanDashboardState();
}

class _ChairmanDashboardState extends State<ChairmanDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthProvider>().role;

    return BackButtonHandler(
      isRoot: true,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: AppSidebar(),

        /// ---------------- APP BAR ----------------
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            role?.displayName ?? 'Dashboard',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: DayNightToggle(),
            ),
          ],
        ),

        /// ---------------- BODY ----------------
        body: Stack(
          children: [
            /// Soft Gradient Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.08),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
            ),

            /// Animated Top Right Blob
            Positioned(
              top: -120,
              right: -80,
              child: _AnimatedBlob(
                size: 310,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                duration: const Duration(seconds: 10),
                offset: 24,
              ),
            ),

            /// Animated Bottom Left Blob
            Positioned(
              bottom: -120,
              left: -80,
              child: _AnimatedBlob(
                size: 250,
                color: Theme.of(
                  context,
                ).colorScheme.secondary.withOpacity(0.12),
                duration: const Duration(seconds: 12),
                offset: 18,
              ),
            ),

            /// Main Content
            SafeArea(
              child: IndexedStack(
                index: _selectedIndex,
                children: const [
                  _HomeDashboardPage(),
                  Center(child: Text('Notifications Page')),
                  Center(child: Text('Profile Page')),
                ],
              ),
            ),
          ],
        ),

        /// ---------------- BOTTOM NAV ----------------
        bottomNavigationBar: AppBottomBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}

/// ---------------- HOME PAGE ----------------
class _HomeDashboardPage extends StatelessWidget {
  const _HomeDashboardPage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [DashboardWidgets()],
      ),
    );
  }
}

/// ---------------- ANIMATED BLOB ----------------
class _AnimatedBlob extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;
  final double offset;

  const _AnimatedBlob({
    required this.size,
    required this.color,
    required this.duration,
    required this.offset,
  });

  @override
  State<_AnimatedBlob> createState() => _AnimatedBlobState();
}

class _AnimatedBlobState extends State<_AnimatedBlob>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -widget.offset,
      end: widget.offset,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value, _animation.value),
          child: Transform.scale(
            scale: 1 + (_animation.value / 220),
            child: child,
          ),
        );
      },
      child: Container(
        height: widget.size,
        width: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.3),
              blurRadius: 80,
              spreadRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChairmanDashboard(),
    ),
  );
}
