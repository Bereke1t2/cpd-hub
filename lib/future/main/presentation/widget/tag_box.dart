import 'package:flutter/material.dart';

import '../../../../core/ui_constants.dart';

class TagBox extends StatelessWidget {
  final String tag;
  const TagBox({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2.0),
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: UiConstants.secondaryButtonColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        tag,
        style: TextStyle(color: UiConstants.mainTextColor, fontSize: 12.0),
      ),
    );
  }
}
