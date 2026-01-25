import '../../model/daily_problem_model.dart';

abstract class MockDailyProblemDataSource {
  Future<DailyProblemModel> getDailyProblem();
}

class MockDailyProblemDataSourceImpl implements MockDailyProblemDataSource {
  @override
  Future<DailyProblemModel> getDailyProblem() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return const DailyProblemModel(
      title: 'Sample Problem Title',
      difficulty: 'Medium',
      tags: ['Array', 'String', 'Dynamic Programming'],
      problemUrl: 'https://example.com/problems/daily',
      problemId: 'daily-problem',
      isLiked: false,
      isDisliked: false,
      isSolved: false,
      numberOfLikes: 90,
      numberOfDislikes: 10,
      numberOfSolvedPeople: 75,
    );
  }
}
