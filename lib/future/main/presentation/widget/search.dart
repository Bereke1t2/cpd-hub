import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';

class SearchBox extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  const SearchBox({super.key, required this.hintText, this.onChanged});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 16.0 * sc, vertical: 12.0 * sc),
      padding: EdgeInsets.symmetric(horizontal: 16.0 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: _isFocused
              ? UiConstants.primaryButtonColor.withValues(alpha: 0.5)
              : UiConstants.borderColor.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _isFocused
                ? UiConstants.primaryButtonColor.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        cursorColor: UiConstants.primaryButtonColor,
        style: TextStyle(color: UiConstants.mainTextColor, fontSize: 15 * sc),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.6), fontSize: 14 * sc),
          border: InputBorder.none,
          icon: Icon(
            Icons.search_rounded,
            color: _isFocused ? UiConstants.primaryButtonColor : UiConstants.subtitleTextColor,
            size: 22 * sc,
          ),
        ),
      ),
    );
  }
}
