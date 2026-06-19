import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lab_portal/features/auth/domain/entity/auth_user_entity.dart';
import 'package:lab_portal/features/auth/domain/usecase/register_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final Register register;

  RegisterBloc({required this.register}) : super(const RegisterInitial()) {
    on<RegisterSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterLoading());
    final result = await register(
      username: event.username,
      fullName: event.fullName,
      email: event.email,
      password: event.password,
    );
    result.fold(
      (user) => emit(RegisterSuccess(user)),
      (failure) => emit(RegisterFailure(failure.message)),
    );
  }
}
