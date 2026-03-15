import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/future/main/domain/entitiy/attendance_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/heatmap_entry_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/rating_point_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/submission_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/user_entity.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_attendance.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_heatmap.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_profile.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_rating_history.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_submissions.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfile getProfile;
  final GetHeatmap getHeatmap;
  final GetRatingHistory getRatingHistory;
  final GetAttendance getAttendance;
  final GetSubmissions getSubmissions;

  ProfileCubit({
    required this.getProfile,
    required this.getHeatmap,
    required this.getRatingHistory,
    required this.getAttendance,
    required this.getSubmissions,
  }) : super(ProfileInitial());

  Future<void> loadProfile(String username) async {
    emit(ProfileLoading());

    final profileResult = await getProfile(username);
    final heatmapResult = await getHeatmap(
      username,
      DateTime.now().month,
      DateTime.now().year,
    );
    final ratingResult = await getRatingHistory(username);
    final attendanceResult = await getAttendance(
      username,
      DateTime.now().month,
      DateTime.now().year,
    );
    final submissionsResult = await getSubmissions(username);

    UserEntity? user;
    List<HeatmapEntryEntity> heatmap = [];
    List<RatingPointEntity> ratings = [];
    List<AttendanceEntity> attendance = [];
    List<SubmissionEntity> submissions = [];

    profileResult.fold((l) => user = l, (_) {});
    heatmapResult.fold((l) => heatmap = l, (_) {});
    ratingResult.fold((l) => ratings = l, (_) {});
    attendanceResult.fold((l) => attendance = l, (_) {});
    submissionsResult.fold((l) => submissions = l, (_) {});

    if (user != null) {
      emit(
        ProfileLoaded(
          user: user!,
          heatmapData: heatmap,
          ratingHistory: ratings,
          attendanceData: attendance,
          submissionData: submissions,
        ),
      );
    } else {
      emit(const ProfileError('Failed to load profile'));
    }
  }

  Future<void> loadAttendanceForMonth(
    String username,
    int month,
    int year,
  ) async {
    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      final result = await getAttendance(username, month, year);
      result.fold(
        (attendance) => emit(
          ProfileLoaded(
            user: current.user,
            heatmapData: current.heatmapData,
            ratingHistory: current.ratingHistory,
            attendanceData: attendance,
            submissionData: current.submissionData,
          ),
        ),
        (_) {},
      );
    }
  }

  Future<void> loadHeatmapForMonth(String username, int month, int year) async {
    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      final result = await getHeatmap(username, month, year);
      result.fold(
        (heatmap) => emit(
          ProfileLoaded(
            user: current.user,
            heatmapData: heatmap,
            ratingHistory: current.ratingHistory,
            attendanceData: current.attendanceData,
            submissionData: current.submissionData,
          ),
        ),
        (_) {},
      );
    }
  }
}
