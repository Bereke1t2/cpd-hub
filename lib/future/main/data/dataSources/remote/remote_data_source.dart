import '../../model/contest_model.dart';
import '../../model/daily_problem_model.dart';
import '../../model/info_model.dart';
import '../../model/problem_model.dart';
import '../../model/user_model.dart';

abstract class RemoteDataSource {

  Future<UserModel> getUserInfo();
  Future<DailyProblemModel> getDailyProblems();
  Future<List<ProblemModel>> getProblems();
  Future<InfoModel> getInfo();
  Future<List<ContestModel>> getContests();
  Future<UserModel> getProfile();
  Future<void> likeProblem(String problemId);
  Future<void> dislikeProblem(String problemId);
  Future<void> markProblemAsSolved(String problemId);
  Future<void> unmarkProblemAsSolved(String problemId);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  @override
  Future<void> dislikeProblem(String problemId) {
    // TODO: implement dislikeProblem
    throw UnimplementedError(); 
  }
  @override
  Future<UserModel> getProfile() {
    // TODO: implement getProfile
    throw UnimplementedError();
  }
  @override
  Future<void> likeProblem(String problemId) {
    // TODO: implement likeProblem
    throw UnimplementedError();
  }
  @override
  Future<InfoModel> getInfo() {
    // TODO: implement getInfo
    throw UnimplementedError();
  }
  @override
  Future<List<ProblemModel>> getProblems() {
    // TODO: implement getProblems
    throw UnimplementedError();
  }
  @override
  Future<UserModel> getUserInfo() {
    // TODO: implement getUserInfo
    throw UnimplementedError();
  }
  @override
  Future<List<ContestModel>> getContests() {
    // TODO: implement getContests
    throw UnimplementedError();
  }
  @override
  Future<DailyProblemModel> getDailyProblems() {
    // TODO: implement getDailyProblems
    throw UnimplementedError();
  }
  @override
  Future<void> markProblemAsSolved(String problemId) {
    // TODO: implement markProblemAsSolved
    throw UnimplementedError();
  }
  @override
  Future<void> unmarkProblemAsSolved(String problemId) {
    // TODO: implement unmarkProblemAsSolved
    throw UnimplementedError();
  }
}
