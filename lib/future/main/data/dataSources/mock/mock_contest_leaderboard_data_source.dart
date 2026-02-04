import '../../model/leaderboard_entry_model.dart';

abstract class MockContestLeaderboardDataSource {
  Future<List<LeaderboardEntryModel>> getLeaderboard(String contestUrl);
}

class MockContestLeaderboardDataSourceImpl
    implements MockContestLeaderboardDataSource {
  @override
  Future<List<LeaderboardEntryModel>> getLeaderboard(String contestUrl) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // contestUrl can be used to return different results per contest.
    return const [
      LeaderboardEntryModel(position: 1, username: 'Bereket', solved: 5, penalty: 412, oldRating: 1580, newRating: 1672),
      LeaderboardEntryModel(position: 2, username: 'Amanuel', solved: 5, penalty: 460, oldRating: 1765, newRating: 1820),
      LeaderboardEntryModel(position: 3, username: 'Samson', solved: 4, penalty: 388, oldRating: 1440, newRating: 1525),
      LeaderboardEntryModel(position: 4, username: 'Hanna', solved: 4, penalty: 430, oldRating: 1320, newRating: 1382),
      LeaderboardEntryModel(position: 5, username: 'Saron', solved: 3, penalty: 305, oldRating: 1210, newRating: 1270),
      LeaderboardEntryModel(position: 6, username: 'Yonathan', solved: 3, penalty: 352, oldRating: 1505, newRating: 1488),
      LeaderboardEntryModel(position: 7, username: 'Miki', solved: 2, penalty: 210, oldRating: 1110, newRating: 1124),
      LeaderboardEntryModel(position: 8, username: 'Ruth', solved: 2, penalty: 245, oldRating: 980, newRating: 1042),
      LeaderboardEntryModel(position: 9, username: 'Abel', solved: 1, penalty: 120, oldRating: 1010, newRating: 986),
      LeaderboardEntryModel(position: 10, username: 'Liya', solved: 1, penalty: 155, oldRating: 1095, newRating: 1080),
    ];
  }
}
