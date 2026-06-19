import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';

class SearchBox extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  const SearchBox({super.key, required this.hintText, this.onChanged});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: UiConstants.primaryButtonColor.withOpacity(0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: UiConstants.subtitleTextColor),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              style: const TextStyle(color: UiConstants.mainTextColor),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: UiConstants.subtitleTextColor),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Tooltip(
            message: 'Clear',
            child: IconButton(
              onPressed: _clear,
              icon: const Icon(
                Icons.close_rounded,
                size: 18,
                color: UiConstants.subtitleTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
