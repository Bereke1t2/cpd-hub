import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/theme/app_spacing.dart';
import 'package:lab_portal/core/widgets/async_view.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import '../../domain/entity/track_entity.dart';
import '../bloc/topics/topics_bloc.dart';
import '../bloc/tracks/tracks_bloc.dart';
import '../widget/track_card.dart';
import 'track_detail_page.dart';

class TracksPage extends StatelessWidget {
  const TracksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<TopicsBloc>()..add(const TopicsStarted()),
        ),
        BlocProvider(
          create: (_) => getIt<TracksBloc>()..add(const TracksStarted()),
        ),
      ],
      child: BasePage(
        title: 'Tracks',
        subtitle: 'Goal-oriented learning paths',
        selectedIndex: 2,
        body: BlocBuilder<TracksBloc, TracksState>(
          builder: (context, tracksState) =>
              BlocBuilder<TopicsBloc, TopicsState>(
            builder: (context, topicsState) {
              // Compute completion only once both are loaded.
              Map<String, double> completion = {};
              List<TrackEntity> tracks = [];

              if (tracksState is TracksLoaded) {
                tracks = tracksState.tracks;
                if (topicsState is TopicsLoaded) {
                  final computed =
                      context.read<TracksBloc>().computeWithProgress(
                            tracks,
                            topicsState,
                          );
                  if (computed != null) {
                    completion = computed.completionById;
                  }
                }
              }

              return AsyncView<List<TrackEntity>>(
                isLoading: tracksState is TracksLoading ||
                    tracksState is TracksInitial,
                error:
                    tracksState is TracksError ? tracksState.message : null,
                data: tracks.isEmpty ? null : tracks,
                isEmpty: (d) => d.isEmpty,
                onRetry: () {
                  context.read<TracksBloc>().add(const TracksStarted());
                  context.read<TopicsBloc>().add(const TopicsStarted());
                },
                emptyMessage: 'No tracks yet',
                builder: (items) => ListView.separated(
                  padding: AppSpacing.pageH.copyWith(
                    top: AppSpacing.sm,
                    bottom: AppSpacing.xl,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) {
                    final t = items[i];
                    return TrackCard(
                      track: t,
                      completion: completion[t.id] ?? 0,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TrackDetailPage(
                            track: t,
                            completion: completion[t.id] ?? 0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
