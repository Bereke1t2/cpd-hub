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
  }) : super(const ProfileState());

  Future<void> loadProfile(String username) async {
    emit(const ProfileState(
      isUserLoading: true,
      isHeatmapLoading: true,
      isRatingLoading: true,
      isAttendanceLoading: true,
      isSubmissionsLoading: true,
    ));

    await Future.wait([
      _loadUser(username),
      _loadHeatmap(username),
      _loadRating(username),
      _loadAttendance(username),
      _loadSubmissions(username),
    ]);
  }

  Future<void> _loadUser(String username) async {
    final result = await getProfile(username);
    result.fold(
      (user) => emit(state.copyWith(user: user, isUserLoading: false)),
      (failure) => emit(state.copyWith(isUserLoading: false, error: failure.message)),
    );
  }

  Future<void> _loadHeatmap(String username) async {
    final result = await getHeatmap(username, DateTime.now().month, DateTime.now().year);
    result.fold(
      (heatmap) => emit(state.copyWith(heatmapData: heatmap, isHeatmapLoading: false)),
      (_) => emit(state.copyWith(isHeatmapLoading: false)),
    );
  }

  Future<void> _loadRating(String username) async {
    final result = await getRatingHistory(username);
    result.fold(
      (ratings) => emit(state.copyWith(ratingHistory: ratings, isRatingLoading: false)),
      (_) => emit(state.copyWith(isRatingLoading: false)),
    );
  }

  Future<void> _loadAttendance(String username) async {
    final now = DateTime.now();
    final result = await getAttendance(username, now.month, now.year);
    result.fold(
      (attendance) => emit(state.copyWith(attendanceData: attendance, isAttendanceLoading: false)),
      (_) => emit(state.copyWith(isAttendanceLoading: false)),
    );
  }

  Future<void> _loadSubmissions(String username) async {
    final result = await getSubmissions(username);
    result.fold(
      (submissions) => emit(state.copyWith(submissionData: submissions, isSubmissionsLoading: false)),
      (_) => emit(state.copyWith(isSubmissionsLoading: false)),
    );
  }

  Future<void> loadAttendanceForMonth(String username, int month, int year) async {
    emit(state.copyWith(isAttendanceLoading: true));
    final result = await getAttendance(username, month, year);
    result.fold(
      (attendance) => emit(state.copyWith(attendanceData: attendance, isAttendanceLoading: false)),
      (_) => emit(state.copyWith(isAttendanceLoading: false)),
    );
  }

  Future<void> loadHeatmapForMonth(String username, int month, int year) async {
    emit(state.copyWith(isHeatmapLoading: true));
    final result = await getHeatmap(username, month, year);
    result.fold(
      (heatmap) => emit(state.copyWith(heatmapData: heatmap, isHeatmapLoading: false)),
      (_) => emit(state.copyWith(isHeatmapLoading: false)),
    );
  }
}
