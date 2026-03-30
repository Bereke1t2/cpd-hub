part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final UserEntity? user;
  final List<HeatmapEntryEntity> heatmapData;
  final List<RatingPointEntity> ratingHistory;
  final List<AttendanceEntity> attendanceData;
  final List<SubmissionEntity> submissionData;
  final bool isUserLoading;
  final bool isHeatmapLoading;
  final bool isRatingLoading;
  final bool isAttendanceLoading;
  final bool isSubmissionsLoading;
  final String? error;

  const ProfileState({
    this.user,
    this.heatmapData = const [],
    this.ratingHistory = const [],
    this.attendanceData = const [],
    this.submissionData = const [],
    this.isUserLoading = false,
    this.isHeatmapLoading = false,
    this.isRatingLoading = false,
    this.isAttendanceLoading = false,
    this.isSubmissionsLoading = false,
    this.error,
  });

  bool get isFullyLoaded =>
      !isUserLoading &&
      !isHeatmapLoading &&
      !isRatingLoading &&
      !isAttendanceLoading &&
      !isSubmissionsLoading;

  ProfileState copyWith({
    UserEntity? user,
    List<HeatmapEntryEntity>? heatmapData,
    List<RatingPointEntity>? ratingHistory,
    List<AttendanceEntity>? attendanceData,
    List<SubmissionEntity>? submissionData,
    bool? isUserLoading,
    bool? isHeatmapLoading,
    bool? isRatingLoading,
    bool? isAttendanceLoading,
    bool? isSubmissionsLoading,
    String? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      heatmapData: heatmapData ?? this.heatmapData,
      ratingHistory: ratingHistory ?? this.ratingHistory,
      attendanceData: attendanceData ?? this.attendanceData,
      submissionData: submissionData ?? this.submissionData,
      isUserLoading: isUserLoading ?? this.isUserLoading,
      isHeatmapLoading: isHeatmapLoading ?? this.isHeatmapLoading,
      isRatingLoading: isRatingLoading ?? this.isRatingLoading,
      isAttendanceLoading: isAttendanceLoading ?? this.isAttendanceLoading,
      isSubmissionsLoading: isSubmissionsLoading ?? this.isSubmissionsLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        user,
        heatmapData,
        ratingHistory,
        attendanceData,
        submissionData,
        isUserLoading,
        isHeatmapLoading,
        isRatingLoading,
        isAttendanceLoading,
        isSubmissionsLoading,
        error,
      ];
}
