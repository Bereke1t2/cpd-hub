import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';

/// Renders the four standard BLoC states (loading / error+retry / empty / data)
/// in one place so every page looks consistent.
///
/// Usage:
/// ```dart
/// AsyncView<List<ProblemEntity>>(
///   isLoading: state is ProblemsLoading,
///   error:     state is ProblemsError ? state.message : null,
///   data:      state is ProblemsLoaded ? state.problems : null,
///   isEmpty:   (d) => d.isEmpty,
///   onRetry:   () => context.read<ProblemsBloc>().add(ProblemsStarted()),
///   builder:   (problems) => ProblemsList(problems),
/// )
/// ```
class AsyncView<T> extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final T? data;
  final bool Function(T data)? isEmpty;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;
  final String emptyMessage;
  final String emptySubtitle;

  const AsyncView({
    super.key,
    required this.isLoading,
    required this.error,
    required this.data,
    required this.builder,
    this.isEmpty,
    this.onRetry,
    this.emptyMessage = 'Nothing here yet',
    this.emptySubtitle = '',
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: UiConstants.primaryButtonColor,
        ),
      );
    }

    if (error != null) {
      return _Placeholder(
        icon: Icons.error_outline_rounded,
        iconColor: Colors.red.shade400,
        title: error!,
        subtitle: 'Pull down to retry or tap the button below.',
        actionLabel: onRetry != null ? 'Retry' : null,
        onAction: onRetry,
      );
    }

    final d = data;
    if (d == null || (isEmpty != null && isEmpty!(d))) {
      return _Placeholder(
        icon: Icons.inbox_outlined,
        iconColor: UiConstants.subtitleTextColor,
        title: emptyMessage,
        subtitle: emptySubtitle,
        actionLabel: onRetry != null ? 'Refresh' : null,
        onAction: onRetry,
      );
    }

    return builder(d);
  }
}

class _Placeholder extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _Placeholder({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: iconColor.withOpacity(0.7)),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: UiConstants.mainTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: UiConstants.subtitleTextColor,
                  fontSize: 13,
                ),
              ),
            ],
            if (actionLabel != null) ...[
              const SizedBox(height: 20),
              FilledButton.tonal(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor:
                      UiConstants.primaryButtonColor.withOpacity(0.15),
                  foregroundColor: UiConstants.primaryButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 12),
                ),
                child: Text(
                  actionLabel!,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
