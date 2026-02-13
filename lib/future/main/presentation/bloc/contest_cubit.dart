import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/future/main/domain/entitiy/contest_entitiy.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_contests.dart';

part 'contest_state.dart';

class ContestCubit extends Cubit<ContestState> {
  final GetContests getContests;

  ContestCubit({required this.getContests}) : super(ContestInitial());

  Future<void> loadContests() async {
    emit(ContestLoading());
    final result = await getContests();
    result.fold(
      (contests) => emit(ContestLoaded(contests)),
      (failure) => emit(ContestError(failure.message)),
    );
  }
}
