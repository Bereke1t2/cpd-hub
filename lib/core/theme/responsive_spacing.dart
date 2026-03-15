import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';

class RRSizedBox extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;
  const RRSizedBox({super.key, this.width, this.height, this.child});

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return SizedBox(
      width: width != null ? width! * sc : null,
      height: height != null ? height! * sc : null,
      child: child,
    );
  }
}
