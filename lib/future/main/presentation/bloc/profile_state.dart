part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity user;
  final List<HeatmapEntryEntity> heatmapData;
  final List<RatingPointEntity> ratingHistory;
  final List<AttendanceEntity> attendanceData;
  final List<SubmissionEntity> submissionData;

  const ProfileLoaded({
    required this.user,
    required this.heatmapData,
    required this.ratingHistory,
    required this.attendanceData,
    required this.submissionData,
  });

  @override
  List<Object?> get props => [
    user,
    heatmapData,
    ratingHistory,
    attendanceData,
    submissionData,
  ];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
  @override
  List<Object?> get props => [message];
}
