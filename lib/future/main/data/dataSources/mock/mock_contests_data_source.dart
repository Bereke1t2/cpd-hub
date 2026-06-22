import '../../model/contest_model.dart';

abstract class MockContestsDataSource {
  Future<List<ContestModel>> getContests();
}

class MockContestsDataSourceImpl implements MockContestsDataSource {
  @override
  Future<List<ContestModel>> getContests() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return const [
      ContestModel(
        id: 'cpd-weekly-1',
        title: 'Weekly Coding Challenge 1',
        contestUrl: 'https://example.com/contests/1',
        startTime: '2026-02-01T10:00:00Z',
        duration: '02:00:00',
        platform: 'CPD Hub',
        numberOfProblems: 5,
        isPast: false,
        isParticipating: false,
      ),
      ContestModel(
        id: 'cpd-weekly-2',
        title: 'Weekly Coding Challenge 2',
        contestUrl: 'https://example.com/contests/2',
        startTime: '2026-02-08T10:00:00Z',
        duration: '02:00:00',
        platform: 'CPD Hub',
        numberOfProblems: 5,
        isPast: false,
        isParticipating: true,
      ),
      ContestModel(
        id: 'cpd-weekly-0',
        title: 'Weekly Coding Challenge 0 (Past)',
        contestUrl: 'https://example.com/contests/0',
        startTime: '2026-01-01T10:00:00Z',
        duration: '02:00:00',
        platform: 'CPD Hub',
        numberOfProblems: 5,
        isPast: true,
        isParticipating: true,
      ),
    ];
  }
}
