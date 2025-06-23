import 'package:flutter/material.dart';

class FloatingFunctionButton extends StatelessWidget {
  final IconData icon;
  final String heroTag;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color foregroundColor;
  final Color backgroundColor;

  const FloatingFunctionButton({
    super.key,
    required this.icon,
    required this.heroTag,
    required this.tooltip,
    required this.onPressed,
    required this.foregroundColor,
    required this.backgroundColor,
  }); // AppBarActionButton

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      tooltip: tooltip,
      onPressed: onPressed,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      child: Icon(icon),
    );
  } // build
} // FloatingFunctionButton
