import '../../model/user_model.dart';

abstract class MockUsersDataSource {
  Future<List<UserModel>> getUsers();
}

class MockUsersDataSourceImpl implements MockUsersDataSource {
  @override
  Future<List<UserModel>> getUsers() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const [
      UserModel(username: 'smartguy',       fullName: 'Smart Guy',      bio: 'I am the smartest guy',                               avatarUrl: '', rating: 2900, rank: '1',  division: 'A', solvedProblems: 412, contributions: 87),
      UserModel(username: 'codewizard',      fullName: 'Code Wizard',    bio: 'Passionate about clean architecture and open-source.',  avatarUrl: '', rating: 2750, rank: '2',  division: 'A', solvedProblems: 380, contributions: 64),
      UserModel(username: 'devops_ninja',    fullName: 'DevOps Ninja',   bio: 'Automating deployments and scaling infrastructure.',   avatarUrl: '', rating: 1500, rank: '3',  division: 'B', solvedProblems: 145, contributions: 22),
      UserModel(username: 'ui_guru',         fullName: 'UI Guru',        bio: 'Design systems advocate and Flutter UI craftsman.',    avatarUrl: '', rating: 3400, rank: '4',  division: 'A', solvedProblems: 520, contributions: 103),
      UserModel(username: 'data_cruncher',   fullName: 'Data Cruncher',  bio: 'ML enthusiast turning data into insights.',            avatarUrl: '', rating: 800,  rank: '5',  division: 'C', solvedProblems: 48,  contributions: 6),
      UserModel(username: 'bug_hunter',      fullName: 'Bug Hunter',     bio: 'Relentless at finding edge cases and race conditions.',avatarUrl: '', rating: 2400, rank: '6',  division: 'B', solvedProblems: 310, contributions: 51),
      UserModel(username: 'async_master',    fullName: 'Async Master',   bio: 'Concurrency, isolates, and streams fanatic.',          avatarUrl: '', rating: 1200, rank: '7',  division: 'C', solvedProblems: 98,  contributions: 14),
      UserModel(username: 'security_sage',   fullName: 'Security Sage',  bio: 'Securing APIs and hardening apps.',                   avatarUrl: '', rating: 950,  rank: '8',  division: 'C', solvedProblems: 72,  contributions: 9),
      UserModel(username: 'test_writer',     fullName: 'Test Writer',    bio: 'TDD believer. Tests before coffee.',                   avatarUrl: '', rating: 2350, rank: '9',  division: 'B', solvedProblems: 295, contributions: 47),
      UserModel(username: 'perf_tuner',      fullName: 'Perf Tuner',     bio: 'Micro-optimisations that add up.',                    avatarUrl: '', rating: 2525, rank: '10', division: 'B', solvedProblems: 330, contributions: 58),
      UserModel(username: 'fullstack_alex',  fullName: 'Fullstack Alex', bio: 'Bridging frontend and backend worlds.',               avatarUrl: '', rating: 2700, rank: '11', division: 'A', solvedProblems: 360, contributions: 72),
      UserModel(username: 'package_builder', fullName: 'Package Builder',bio: 'Publishing reusable Dart & Flutter packages.',        avatarUrl: '', rating: 2450, rank: '12', division: 'B', solvedProblems: 280, contributions: 43),
    ];
  }
}
