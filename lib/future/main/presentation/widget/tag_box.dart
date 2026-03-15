import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';

import '../../../../core/ui_constants.dart';

class TagBox extends StatelessWidget {
  final String tag;
  const TagBox({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0 * sc, horizontal: 10.0 * sc),
      decoration: BoxDecoration(
        color: UiConstants.secondaryButtonColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tag,
        style: TextStyle(color: UiConstants.mainTextColor, fontSize: 11.0 * sc, fontWeight: FontWeight.w500),
      ),
    );
  }
}
