import 'package:flutter/material.dart';

class IconActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const IconActionButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.isEnabled,
  }); // AppBarActionButton

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: isEnabled ? Colors.black : Colors.grey),
      tooltip: tooltip,
      onPressed: isEnabled ? onPressed : null,
    );
  } // build
} // AppBarActionButton
