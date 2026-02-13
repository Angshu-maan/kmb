import 'package:flutter/material.dart';
import 'package:kmb_app/features/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class DayNightToggle extends StatelessWidget {
  const DayNightToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return GestureDetector(
      onTap: themeProvider.toggleTheme,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        width: 80,
        height: 40,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: themeProvider.isDark
              ? const LinearGradient(
                  colors: [Color(0xFF0F2027), Color(0xFF203A43)],
                )
              : const LinearGradient(
                  colors: [Color(0xFF87CEFA), Colors.white],
                ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 600),
          alignment: themeProvider.isDark
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) =>
                RotationTransition(
                  turns: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                ),
            child: Icon(
              themeProvider.isDark
                  ? Icons.nightlight_round
                  : Icons.wb_sunny,
              key: ValueKey(themeProvider.isDark),
              color: themeProvider.isDark
                  ? Colors.white
                  : Colors.orange,
            ),
          ),
        ),
      ),
    );
  }
}
