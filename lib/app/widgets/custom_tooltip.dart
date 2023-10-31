import 'package:flutter/material.dart';

import '../../core/theme/style.dart';

class CustomToolTip extends StatelessWidget {
  const CustomToolTip(
      {super.key,
      required this.onPressed,
      required this.label,
      required this.icon});
  final void Function() onPressed;
  final String label;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      preferBelow: false,
      decoration: BoxDecoration(
        color: englishViolet,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: englishViolet,
          size: 21,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
