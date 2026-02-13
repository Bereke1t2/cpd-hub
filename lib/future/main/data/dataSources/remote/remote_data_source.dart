import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cpd_hub/core/url_constants.dart';
import '../../model/activity_model.dart';
import '../../model/attendance_model.dart';
import '../../model/contest_model.dart';
import '../../model/daily_problem_model.dart';
import '../../model/heatmap_entry_model.dart';
import '../../model/info_model.dart';
import '../../model/leaderboard_entry_model.dart';
import '../../model/problem_model.dart';
import '../../model/rating_point_model.dart';
import '../../model/rating_point_model.dart';
import '../../model/social_link_model.dart';
import '../../model/submission_model.dart';
import '../../model/user_model.dart';

abstract class RemoteDataSource {
  Future<List<ProblemModel>> getProblems();
  Future<DailyProblemModel> getDailyProblems();
  Future<List<ContestModel>> getContests();
  Future<UserModel> getProfile(String username);
  Future<InfoModel> getInfo();
  Future<void> likeProblem(String problemId);
  Future<void> dislikeProblem(String problemId);
  Future<void> markProblemAsSolved(String problemId);
  Future<void> unmarkProblemAsSolved(String problemId);
  Future<List<UserModel>> getUsers();
  Future<List<LeaderboardEntryModel>> getLeaderboard(String contestId);
  Future<List<ActivityModel>> getActivityFeed();
  Future<List<AttendanceModel>> getAttendance(String username, int month, int year);
  Future<List<HeatmapEntryModel>> getHeatmap(String username, int month, int year);
  Future<List<RatingPointModel>> getRatingHistory(String username);
  Future<List<SubmissionModel>> getSubmissions(String username);
  Future<List<InfoModel>> getInfoList();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  // TODO: Replace with dynamic token management
  final String _authToken = 'Bearer YOUR_TOKEN_HERE';
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': _authToken,
      };

  RemoteDataSourceImpl({required this.client});

  // ──────────────────────────── Problems ────────────────────────────

  @override
  Future<List<ProblemModel>> getProblems() async {
    try {
      final response = await client.get(
        Uri.parse(UrlConstants.problems),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => ProblemModel.fromJson(item)).toList();
      }
    } catch (_) {}
    // Mock fallback
    return _mockProblems();
  }

  @override
  Future<DailyProblemModel> getDailyProblems() async {
    try {
      final response = await client.get(
        Uri.parse(UrlConstants.dailyProblem),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        return DailyProblemModel.fromJson(json.decode(response.body));
      }
    } catch (_) {}
    return _mockDailyProblem();
  }

  @override
  Future<void> likeProblem(String problemId) async {
    try {
      await client.post(
        Uri.parse(UrlConstants.likeProblem(problemId)),
        headers: _headers,
      );
    } catch (_) {}
  }

  @override
  Future<void> dislikeProblem(String problemId) async {
    try {
      await client.post(
        Uri.parse(UrlConstants.dislikeProblem(problemId)),
        headers: _headers,
      );
    } catch (_) {}
  }

  @override
  Future<void> markProblemAsSolved(String problemId) async {
    try {
      await client.post(
        Uri.parse(UrlConstants.solveProblem(problemId)),
        headers: _headers,
      );
    } catch (_) {}
  }

  @override
  Future<void> unmarkProblemAsSolved(String problemId) async {
    try {
      await client.delete(
        Uri.parse(UrlConstants.solveProblem(problemId)),
        headers: _headers,
      );
    } catch (_) {}
  }

  // ──────────────────────────── Contests ────────────────────────────

  @override
  Future<List<ContestModel>> getContests() async {
    try {
      final response = await client.get(
        Uri.parse(UrlConstants.contests),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => ContestModel.fromJson(item)).toList();
      }
    } catch (_) {}
    return _mockContests();
  }

  @override
  Future<List<LeaderboardEntryModel>> getLeaderboard(String contestId) async {
    try {
      final response = await client.get(
        Uri.parse(UrlConstants.leaderboard(contestId)),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => LeaderboardEntryModel.fromJson(item)).toList();
      }
    } catch (_) {}
    return _mockLeaderboard();
  }

  // ──────────────────────────── Users ────────────────────────────

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await client.get(
        Uri.parse(UrlConstants.users),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => UserModel.fromJson(item)).toList();
      }
    } catch (_) {}
    return _mockUsers();
  }

  @override
  Future<UserModel> getProfile(String username) async {
    try {
      final response = await client.get(
        Uri.parse(UrlConstants.profile(username)),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(json.decode(response.body));
      }
    } catch (_) {}
    return _mockProfile();
  }

  // ──────────────────────────── Activity ────────────────────────────

  @override
  Future<List<ActivityModel>> getActivityFeed() async {
    try {
      final response = await client.get(
        Uri.parse(UrlConstants.activityFeed),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => ActivityModel.fromJson(item)).toList();
      }
    } catch (_) {}
    return _mockActivity();
  }

  // ──────────────────────────── Profile Analytics ────────────────────────────

  @override
  Future<List<HeatmapEntryModel>> getHeatmap(String username, int month, int year) async {
    try {
      final response = await client.get(
        Uri.parse('${UrlConstants.heatmap(username)}?month=$month&year=$year'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => HeatmapEntryModel.fromJson(item)).toList();
      }
    } catch (_) {}
    return _mockHeatmap(month, year);
  }

  @override
  Future<List<RatingPointModel>> getRatingHistory(String username) async {
    try {
      final response = await client.get(
        Uri.parse(UrlConstants.ratingHistory(username)),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => RatingPointModel.fromJson(item)).toList();
      }
    } catch (_) {}
    return _mockRatingHistory();
  }

  @override
  Future<List<SubmissionModel>> getSubmissions(String username) async {
    try {
      final response = await client.get(
        Uri.parse(UrlConstants.submissions(username)),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => SubmissionModel.fromJson(item)).toList();
      }
    } catch (_) {}
    return _mockSubmissions();
  }

  @override
  Future<List<AttendanceModel>> getAttendance(String username, int month, int year) async {
    try {
      final response = await client.get(
        Uri.parse('${UrlConstants.attendance(username)}?month=$month&year=$year'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => AttendanceModel.fromJson(item)).toList();
      }
    } catch (_) {}
    return _mockAttendance(month, year);
  }

  // ──────────────────────────── Info ────────────────────────────

  @override
  Future<InfoModel> getInfo() async {
    try {
      final response = await client.get(
        Uri.parse(UrlConstants.info),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        return InfoModel.fromJson(json.decode(response.body));
      }
    } catch (_) {}
    return const InfoModel(title: 'Welcome', description: 'Welcome to CPD Hub');
  }

  @override
  Future<List<InfoModel>> getInfoList() async {
    try {
      final response = await client.get(
        Uri.parse(UrlConstants.info),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => InfoModel.fromJson(item)).toList();
      }
    } catch (_) {}
    return _mockInfoList();
  }

  // ═══════════════════════════════════════════════════════════════
  //  MOCK DATA — used when the backend is not yet available
  // ═══════════════════════════════════════════════════════════════

  List<ProblemModel> _mockProblems() => const [
        ProblemModel(title: 'Two Sum', difficulty: 'Easy', tags: ['Array', 'Hash Table'], numberOfLikes: 245, numberOfDislikes: 12, problemUrl: '', problemId: 'p1', isLiked: false, isDisliked: false, isSolved: true),
        ProblemModel(title: 'Longest Substring Without Repeating', difficulty: 'Medium', tags: ['String', 'Sliding Window'], numberOfLikes: 189, numberOfDislikes: 5, problemUrl: '', problemId: 'p2', isLiked: true, isDisliked: false, isSolved: false),
        ProblemModel(title: 'Median of Two Sorted Arrays', difficulty: 'Hard', tags: ['Array', 'Binary Search'], numberOfLikes: 320, numberOfDislikes: 8, problemUrl: '', problemId: 'p3', isLiked: false, isDisliked: false, isSolved: false),
        ProblemModel(title: 'Valid Parentheses', difficulty: 'Easy', tags: ['Stack', 'String'], numberOfLikes: 156, numberOfDislikes: 3, problemUrl: '', problemId: 'p4', isLiked: false, isDisliked: false, isSolved: true),
        ProblemModel(title: 'Merge Intervals', difficulty: 'Medium', tags: ['Array', 'Sorting'], numberOfLikes: 210, numberOfDislikes: 7, problemUrl: '', problemId: 'p5', isLiked: false, isDisliked: false, isSolved: false),
        ProblemModel(title: 'Binary Tree Level Order', difficulty: 'Medium', tags: ['Tree', 'BFS'], numberOfLikes: 134, numberOfDislikes: 4, problemUrl: '', problemId: 'p6', isLiked: false, isDisliked: false, isSolved: true),
        ProblemModel(title: 'Maximum Subarray', difficulty: 'Medium', tags: ['Array', 'Dynamic Programming'], numberOfLikes: 275, numberOfDislikes: 11, problemUrl: '', problemId: 'p7', isLiked: true, isDisliked: false, isSolved: true),
        ProblemModel(title: 'Word Break', difficulty: 'Hard', tags: ['Dynamic Programming', 'Trie'], numberOfLikes: 88, numberOfDislikes: 15, problemUrl: '', problemId: 'p8', isLiked: false, isDisliked: false, isSolved: false),
      ];

  DailyProblemModel _mockDailyProblem() => const DailyProblemModel(
        title: 'Longest Common Subsequence',
        difficulty: 'Medium',
        tags: ['Dynamic Programming', 'String'],
        problemUrl: '',
        problemId: 'dp1',
        isLiked: false,
        isDisliked: false,
        isSolved: false,
        numberOfLikes: 342,
        numberOfDislikes: 18,
        numberOfSolvedPeople: 1250,
      );

  List<ContestModel> _mockContests() => const [
        ContestModel(id: 'c1', title: 'Global Round #26', contestUrl: '', startTime: '2026-02-15T10:00:00Z', duration: '2h 30m', platform: 'CPD Hub', numberOfProblems: 6, numberOfContestants: 1240, date: 'Feb 15, 2026', isPast: false, isParticipating: true),
        ContestModel(id: 'c2', title: 'Educational #152', contestUrl: '', startTime: '2026-02-18T14:00:00Z', duration: '2h 0m', platform: 'CPD Hub', numberOfProblems: 5, numberOfContestants: 890, date: 'Feb 18, 2026', isPast: false, isParticipating: false),
        ContestModel(id: 'c3', title: 'Div. 3 Challenge', contestUrl: '', startTime: '2026-02-20T16:00:00Z', duration: '2h 15m', platform: 'CPD Hub', numberOfProblems: 7, numberOfContestants: 2100, date: 'Feb 20, 2026', isPast: false, isParticipating: false),
        ContestModel(id: 'c4', title: 'Weekly Round #48', contestUrl: '', startTime: '2026-02-01T10:00:00Z', duration: '1h 30m', platform: 'CPD Hub', numberOfProblems: 4, numberOfContestants: 560, date: 'Feb 1, 2026', isPast: true, isParticipating: true),
        ContestModel(id: 'c5', title: 'Div. 2 Round #890', contestUrl: '', startTime: '2026-01-25T10:00:00Z', duration: '2h 0m', platform: 'CPD Hub', numberOfProblems: 5, numberOfContestants: 1100, date: 'Jan 25, 2026', isPast: true, isParticipating: false),
      ];

  List<LeaderboardEntryModel> _mockLeaderboard() => const [
        LeaderboardEntryModel(rank: 1, username: 'tourist', rating: 3800, score: 600, penalty: 45, problemsSolved: ['A', 'B', 'C', 'D', 'E', 'F']),
        LeaderboardEntryModel(rank: 2, username: 'jiangly', rating: 3650, score: 550, penalty: 62, problemsSolved: ['A', 'B', 'C', 'D', 'E']),
        LeaderboardEntryModel(rank: 3, username: 'ecnerwala', rating: 3400, score: 500, penalty: 78, problemsSolved: ['A', 'B', 'C', 'D']),
        LeaderboardEntryModel(rank: 4, username: 'bereket', rating: 1750, score: 400, penalty: 95, problemsSolved: ['A', 'B', 'C']),
        LeaderboardEntryModel(rank: 5, username: 'coder42', rating: 1600, score: 350, penalty: 110, problemsSolved: ['A', 'B', 'C']),
        LeaderboardEntryModel(rank: 6, username: 'algo_master', rating: 1450, score: 300, penalty: 125, problemsSolved: ['A', 'B']),
        LeaderboardEntryModel(rank: 7, username: 'dev_ninja', rating: 1300, score: 250, penalty: 140, problemsSolved: ['A', 'B']),
        LeaderboardEntryModel(rank: 8, username: 'code_wizard', rating: 1200, score: 200, penalty: 155, problemsSolved: ['A']),
      ];

  List<UserModel> _mockUsers() => const [
        UserModel(
          username: 'bereket',
          fullName: 'Bereket Lemma',
          bio: 'Competitive programmer',
          avatarUrl: '',
          rating: 1750,
          rank: 'Expert',
          division: 'Div 1',
          solvedProblems: 120,
          contributions: 45,
          globalRank: 1204,
          attendedContestsCount: 24,
          socialLinks: [
            SocialLinkModel(platform: 'LeetCode', url: 'https://leetcode.com/bereket', handle: 'bereket'),
            SocialLinkModel(platform: 'Codeforces', url: 'https://codeforces.com/profile/bereket', handle: 'bereket_cf'),
          ],
        ),
        UserModel(
          username: 'abel',
          fullName: 'Abel Tadesse',
          bio: 'Full-stack developer',
          avatarUrl: '',
          rating: 2100,
          rank: 'Candidate Master',
          division: 'Div 1',
          solvedProblems: 180,
          contributions: 62,
          globalRank: 500,
          attendedContestsCount: 40,
          socialLinks: [],
        ),
        UserModel(
          username: 'sara',
          fullName: 'Sara Mohammed',
          bio: 'AI enthusiast',
          avatarUrl: '',
          rating: 1450,
          rank: 'Specialist',
          division: 'Div 2',
          solvedProblems: 85,
          contributions: 30,
          globalRank: 3500,
          attendedContestsCount: 15,
          socialLinks: [],
        ),
        UserModel(
          username: 'dawit',
          fullName: 'Dawit Bekele',
          bio: 'Backend wizard',
          avatarUrl: '',
          rating: 1900,
          rank: 'Expert',
          division: 'Div 1',
          solvedProblems: 150,
          contributions: 55,
          globalRank: 800,
          attendedContestsCount: 30,
          socialLinks: [],
        ),
        UserModel(
          username: 'hanna',
          fullName: 'Hanna Girma',
          bio: 'Problem solver',
          avatarUrl: '',
          rating: 1200,
          rank: 'Pupil',
          division: 'Div 3',
          solvedProblems: 50,
          contributions: 15,
          globalRank: 5000,
          attendedContestsCount: 5,
          socialLinks: [],
        ),
        UserModel(
          username: 'yonas',
          fullName: 'Yonas Tesfaye',
          bio: 'Math olympiad gold',
          avatarUrl: '',
          rating: 2400,
          rank: 'International Master',
          division: 'Div 1',
          solvedProblems: 300,
          contributions: 90,
          globalRank: 100,
          attendedContestsCount: 60,
          socialLinks: [],
        ),
      ];

  UserModel _mockProfile() => const UserModel(
        username: 'bereket',
        fullName: 'Bereket Lemma',
        bio: 'Competitive programmer | CPD Hub enthusiast',
        avatarUrl: '',
        rating: 1750,
        rank: 'Expert',
        division: 'Div 1',
        solvedProblems: 120,
        contributions: 45,
        globalRank: 1204,
        attendedContestsCount: 24,
        socialLinks: [
          SocialLinkModel(platform: 'LeetCode', url: 'https://leetcode.com/bereket', handle: 'bereket'),
          SocialLinkModel(platform: 'Codeforces', url: 'https://codeforces.com/profile/bereket', handle: 'bereket_cf'),
          SocialLinkModel(platform: 'LinkedIn', url: 'https://linkedin.com/in/bereket', handle: 'Bereket Lemma'),
          SocialLinkModel(platform: 'Telegram', url: 'https://t.me/bereket_dev', handle: '@bereket_dev'),
        ],
      );

  List<ActivityModel> _mockActivity() => const [
        ActivityModel(id: 'a1', username: 'abel', action: "solved 'Two Sum' in 3 min", type: 'Solve', timestamp: '2 min ago'),
        ActivityModel(id: 'a2', username: 'sara', action: 'Rating increased to 1450 (+25)', type: 'Rating', timestamp: '15 min ago'),
        ActivityModel(id: 'a3', username: 'dawit', action: "earned 'Problem Crusher' badge", type: 'Badge', timestamp: '1h ago'),
        ActivityModel(id: 'a4', username: 'bereket', action: "solved 'Merge Intervals'", type: 'Solve', timestamp: '2h ago'),
        ActivityModel(id: 'a5', username: 'yonas', action: 'Won Global Round #25 🏆', type: 'Badge', timestamp: '5h ago'),
      ];

  List<HeatmapEntryModel> _mockHeatmap(int month, int year) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    return List.generate(daysInMonth, (i) {
      final day = i + 1;
      final dateStr = '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
      // Simulate varying activity levels
      int solveCount = 0;
      if (day % 2 == 0) solveCount = (day % 5) + 1;
      if (day % 7 == 0) solveCount = 0;
      return HeatmapEntryModel(date: dateStr, solveCount: solveCount);
    });
  }

  List<RatingPointModel> _mockRatingHistory() => const [
        RatingPointModel(date: '2025-08-01', rating: 1000),
        RatingPointModel(date: '2025-09-01', rating: 1200),
        RatingPointModel(date: '2025-10-01', rating: 1100),
        RatingPointModel(date: '2025-11-01', rating: 1400),
        RatingPointModel(date: '2025-12-01', rating: 1500),
        RatingPointModel(date: '2026-01-01', rating: 1750),
      ];

  List<AttendanceModel> _mockAttendance(int month, int year) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    return List.generate(daysInMonth, (i) {
      final day = i + 1;
      final dateStr = '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
      String status;
      if ((day + 3) % 11 == 0) {
        status = 'Absent';
      } else if ((day + 7) % 13 == 0) {
        status = 'Excused';
      } else {
        status = 'Present';
      }
      return AttendanceModel(date: dateStr, status: status);
    });
  }

  List<SubmissionModel> _mockSubmissions() => const [
        SubmissionModel(
          id: 's1',
          problemId: 'p1',
          problemTitle: 'Two Sum',
          status: 'Accepted',
          language: 'Python',
          executionTime: '45ms',
          memoryUsed: '14.2MB',
          timestamp: '2 hours ago',
        ),
        SubmissionModel(
          id: 's2',
          problemId: 'p2',
          problemTitle: 'Longest Substring Without Repeating',
          status: 'Wrong Answer',
          language: 'Java',
          executionTime: '0ms',
          memoryUsed: '24.5MB',
          timestamp: '1 day ago',
        ),
        SubmissionModel(
          id: 's3',
          problemId: 'p4',
          problemTitle: 'Valid Parentheses',
          status: 'Accepted',
          language: 'Dart',
          executionTime: '12ms',
          memoryUsed: '8.1MB',
          timestamp: '3 days ago',
        ),
        SubmissionModel(
          id: 's4',
          problemId: 'p7',
          problemTitle: 'Maximum Subarray',
          status: 'Time Limit Exceeded',
          language: 'C++',
          executionTime: '2000ms',
          memoryUsed: '12.4MB',
          timestamp: '1 week ago',
        ),
        SubmissionModel(
          id: 's5',
          problemId: 'p6',
          problemTitle: 'Binary Tree Level Order',
          status: 'Accepted',
          language: 'Python',
          executionTime: '32ms',
          memoryUsed: '15.6MB',
          timestamp: '2 weeks ago',
        ),
      ];

  List<InfoModel> _mockInfoList() => const [
        InfoModel(title: 'System Maintenance', description: 'Scheduled maintenance on Feb 20th from 2-4 AM'),
        InfoModel(title: 'New Feature: Heatmaps', description: 'Track your coding consistency with the new heatmap feature!'),
        InfoModel(title: 'Contest Update', description: 'Global Round #26 registration is now open'),
      ];
}
