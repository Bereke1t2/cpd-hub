import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/track_entity.dart';
import '../../../domain/service/learning_path_engine.dart';
import '../../../domain/usecase/get_tracks.dart';
import '../topics/topics_bloc.dart';

part 'tracks_event.dart';
part 'tracks_state.dart';

class TracksBloc extends Bloc<TracksEvent, TracksState> {
  final GetTracks getTracks;

  TracksBloc({required this.getTracks}) : super(const TracksInitial()) {
    on<TracksStarted>(_onStarted);
  }

  Future<void> _onStarted(
    TracksStarted event,
    Emitter<TracksState> emit,
  ) async {
    emit(const TracksLoading());
    final result = await getTracks();
    result.fold(
      (tracks) => emit(TracksLoaded(
        tracks: tracks,
        completionById: const {}, // populated via updateProgress
      )),
      (failure) => emit(TracksError(failure.message)),
    );
  }

  /// Recompute track completion percentages from latest [TopicsLoaded] state.
  TracksLoaded? computeWithProgress(
    List<TrackEntity> tracks,
    TopicsLoaded topicsState,
  ) {
    final progress = topicsState.progress;
    final completionById = <String, double>{};

    for (final track in tracks) {
      if (track.topicIds.isEmpty) {
        completionById[track.id] = 0;
        continue;
      }
      final done = track.topicIds
          .where((id) => progress[id]?.status == TopicStatus.completed)
          .length;
      completionById[track.id] = done / track.topicIds.length;
    }

    return TracksLoaded(tracks: tracks, completionById: completionById);
  }
}
