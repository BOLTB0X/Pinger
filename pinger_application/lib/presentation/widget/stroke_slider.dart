import 'package:flutter/material.dart';

class StrokeSlider extends StatelessWidget implements PreferredSizeWidget {
  final double strokeWidth;
  final ValueChanged<double> onChanged;

  const StrokeSlider({
    super.key,
    required this.strokeWidth,
    required this.onChanged,
  }); // StrokeSlider

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.brush, size: 20, color: Colors.black),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.black,
                inactiveTrackColor: Colors.black26,
                thumbColor: Colors.black,
                overlayColor: Colors.black.withValues(alpha: 0.2),
              ),
              child: Slider(
                min: 1.0,
                max: 20.0,
                divisions: 19,
                label: '${strokeWidth.round()} px',
                value: strokeWidth,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  } // build

  @override
  Size get preferredSize => const Size.fromHeight(80);
} // StrokeSlider
