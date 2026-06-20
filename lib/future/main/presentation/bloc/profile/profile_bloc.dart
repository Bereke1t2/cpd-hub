import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lab_portal/future/main/domain/entity/user_entity.dart';
import 'package:lab_portal/future/main/domain/usecase/get_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfile;

  ProfileBloc({required this.getProfile}) : super(const ProfileInitial()) {
    on<ProfileStarted>(_onStarted);
  }

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    final result = await getProfile();
    result.fold(
      (user) => emit(ProfileLoaded(user)),
      (failure) => emit(ProfileError(failure.message)),
    );
  }
}
