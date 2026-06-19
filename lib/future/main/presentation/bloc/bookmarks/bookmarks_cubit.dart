import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists a set of bookmarked problem IDs in SharedPreferences.
/// State is the current Set<String> of bookmarked IDs.
class BookmarksCubit extends Cubit<Set<String>> {
  static const _key = 'bookmarked_problems';
  final SharedPreferences _prefs;

  BookmarksCubit(this._prefs) : super(_load(_prefs));

  static Set<String> _load(SharedPreferences prefs) =>
      Set<String>.from(prefs.getStringList(_key) ?? []);

  bool isBookmarked(String problemId) => state.contains(problemId);

  Future<void> toggle(String problemId) async {
    final next = Set<String>.from(state);
    if (next.contains(problemId)) {
      next.remove(problemId);
    } else {
      next.add(problemId);
    }
    emit(next);
    await _prefs.setStringList(_key, next.toList());
  }
}
