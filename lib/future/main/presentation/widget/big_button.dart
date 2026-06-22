import 'package:flutter/material.dart';
import 'package:lab_portal/core/widgets/primary_button.dart';

/// Thin wrapper kept for backward-compat. Prefer PrimaryButton directly.
class BigButton extends StatelessWidget {
  final String title;
  final double fontSize;
  final VoidCallback onPressed;

  const BigButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.fontSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(title: title, onPressed: onPressed);
  }
}
