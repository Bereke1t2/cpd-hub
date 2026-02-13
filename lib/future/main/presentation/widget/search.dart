import 'package:flutter/material.dart';
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: _isFocused 
              ? UiConstants.primaryButtonColor.withOpacity(0.5) 
              : UiConstants.borderColor.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _isFocused 
                ? UiConstants.primaryButtonColor.withOpacity(0.1) 
                : Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        cursorColor: UiConstants.primaryButtonColor,
        style: const TextStyle(color: UiConstants.mainTextColor, fontSize: 15),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.6)),
          border: InputBorder.none,
          icon: Icon(
            Icons.search_rounded, 
            color: _isFocused ? UiConstants.primaryButtonColor : UiConstants.subtitleTextColor,
            size: 22,
          ),
        ),
      ),
    );
  }
}