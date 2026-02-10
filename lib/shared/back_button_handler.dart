import 'package:flutter/material.dart';

class BackButtonHandler extends StatefulWidget {
  final Widget child;
  final bool isRoot;

  const BackButtonHandler({
    required this.child,
    this.isRoot = false,
    super.key,
  });

  @override
  State<BackButtonHandler> createState() => _BackButtonHandlerState();
}

class _BackButtonHandlerState extends State<BackButtonHandler> {
  DateTime? _lastPressed;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isRoot) {
          final now = DateTime.now();
          if (_lastPressed == null ||
              now.difference(_lastPressed!) > const Duration(seconds: 2)) {
            _lastPressed = now;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Press back again to exit'),
                duration: Duration(seconds: 2),
              ),
            );
            return false; // prevent exit
          }
          return true; // exit app
        } else {
          return true; // pop normally
        }
      },
      child: widget.child,
    );
  }
}
