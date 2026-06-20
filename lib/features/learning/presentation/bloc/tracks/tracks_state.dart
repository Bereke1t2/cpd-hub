part of 'tracks_bloc.dart';

abstract class TracksState extends Equatable {
  const TracksState();
  @override
  List<Object?> get props => [];
}

class TracksInitial extends TracksState {
  const TracksInitial();
}

class TracksLoading extends TracksState {
  const TracksLoading();
}

/// [completionById] maps track.id → fraction of topics completed (0..1).
class TracksLoaded extends TracksState {
  final List<TrackEntity> tracks;
  final Map<String, double> completionById;

  const TracksLoaded({required this.tracks, required this.completionById});

  @override
  List<Object?> get props => [tracks, completionById];
}

class TracksError extends TracksState {
  final String message;
  const TracksError(this.message);
  @override
  List<Object?> get props => [message];
}
