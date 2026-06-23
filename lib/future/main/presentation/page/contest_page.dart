import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/app_text.dart';
import 'package:lab_portal/core/widgets/async_view.dart';
import 'package:lab_portal/future/main/domain/entity/contest_entity.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import 'package:lab_portal/future/main/presentation/widget/contest_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/contests/contests_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';

import 'package:lab_portal/future/main/presentation/page/contest_leaderboard_page.dart';

class ContestPage extends StatelessWidget {
  const ContestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ContestsBloc>()..add(ContestsStarted()),
      child: BasePage(
        title: 'Contests',
        selectedIndex: 3,
        subtitle: 'Upcoming & past contests',
        body: Column(
          children: [
            // Platform filter chips — derived from real data
            BlocBuilder<ContestsBloc, ContestsState>(
              builder: (context, state) {
                if (state is! ContestsLoaded) return const SizedBox.shrink();
                final platforms = state.platforms;
                final current = state.platform;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(AppDimens.md,
                      AppDimens.md, AppDimens.md, AppDimens.xs),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: platforms
                          .map((p) => Padding(
                                padding: const EdgeInsets.only(
                                    right: AppDimens.sm),
                                child: _PlatformChip(
                                  label: p,
                                  selected: current == p,
                                  onTap: () => context
                                      .read<ContestsBloc>()
                                      .add(ContestsFilterChanged(p)),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<ContestsBloc, ContestsState>(
                builder: (context, state) =>
                    AsyncView<List<ContestEntity>>(
                  isLoading:
                      state is ContestsLoading || state is ContestsInitial,
                  error: state is ContestsError ? state.message : null,
                  data: state is ContestsLoaded ? state.contests : null,
                  isEmpty: (d) => d.isEmpty,
                  onRetry: () =>
                      context.read<ContestsBloc>().add(ContestsStarted()),
                  emptyMessage: 'No contests available',
                  builder: (contests) {
                    // Live now → soonest to end first.
                    final live = contests
                        .where((c) => c.isRunning)
                        .toList()
                      ..sort((a, b) => a.endsAt.compareTo(b.endsAt));
                    // Upcoming → soonest to start first.
                    final upcoming = contests
                        .where((c) => c.isUpcoming)
                        .toList()
                      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
                    // Everything else (finished) → most recent first.
                    final past = contests
                        .where((c) => !c.isRunning && !c.isUpcoming)
                        .toList()
                      ..sort((a, b) => b.startsAt.compareTo(a.startsAt));

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (live.isNotEmpty) ...[
                            _SectionTitle('Live now'),
                            ...live.map((c) => RepaintBoundary(
                                  child: ContestCard(
                                    contest: c,
                                    onTap: () => _openLeaderboard(context, c),
                                  ),
                                )),
                          ],
                          if (upcoming.isNotEmpty) ...[
                            _SectionTitle('Upcoming'),
                            ...upcoming.map((c) => RepaintBoundary(
                                  child: ContestCard(
                                    contest: c,
                                    onTap: () => _openLeaderboard(context, c),
                                  ),
                                )),
                          ],
                          if (past.isNotEmpty) ...[
                            _SectionTitle('Past'),
                            ...past.map((c) => RepaintBoundary(
                                  child: ContestCard(
                                    contest: c,
                                    onTap: () => _openLeaderboard(context, c),
                                  ),
                                )),
                          ],
                          const SizedBox(height: AppDimens.md),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openLeaderboard(BuildContext context, ContestEntity c) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => ContestLeaderboardPage(contest: c)),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppDimens.md, AppDimens.lg, AppDimens.md, AppDimens.sm),
      child: AppText.h2(text),
    );
  }
}

class _PlatformChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PlatformChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? UiConstants.primaryButtonColor
        : UiConstants.subtitleTextColor;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.md, vertical: AppDimens.xs),
        decoration: BoxDecoration(
          color: selected
              ? UiConstants.primaryButtonColor.withValues(alpha: 0.18)
              : UiConstants.infoBackgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.rPill)),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: AppDimens.fCaption,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
