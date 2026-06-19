// lib/core/widgets/async_view.dart
//
// One widget to render the standard four BLoC states (Phase 6):
// loading spinner / error + retry / empty / data. Keeps every page consistent.

import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';

class AsyncView<T> extends StatelessWidget {
  final bool isLoading;
  final String? error;          // non-null => error state
  final T? data;                // non-null => data available
  final bool Function(T data)? isEmpty;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;
  final String emptyMessage;

  const AsyncView({
    super.key,
    required this.isLoading,
    required this.error,
    required this.data,
    required this.builder,
    this.isEmpty,
    this.onRetry,
    this.emptyMessage = 'Nothing here yet',
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return _Message(
        icon: Icons.error_outline,
        text: error!,
        actionLabel: onRetry != null ? 'Retry' : null,
        onAction: onRetry,
      );
    }

    final d = data;
    if (d == null || (isEmpty != null && isEmpty!(d))) {
      return _Message(
        icon: Icons.inbox_outlined,
        text: emptyMessage,
        actionLabel: onRetry != null ? 'Refresh' : null,
        onAction: onRetry,
      );
    }

    return builder(d);
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _Message({
    required this.icon,
    required this.text,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: UiConstants.subtitleTextColor),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: UiConstants.subtitleTextColor),
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
