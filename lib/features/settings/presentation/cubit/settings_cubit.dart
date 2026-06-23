import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User-adjustable preferences, persisted in SharedPreferences so they survive
/// app restarts. New flags can be added by extending [SettingsState] + the
/// load/setters here.
class SettingsState extends Equatable {
  final bool dailyReminder;
  final bool contestAlerts;

  const SettingsState({
    this.dailyReminder = true,
    this.contestAlerts = true,
  });

  SettingsState copyWith({bool? dailyReminder, bool? contestAlerts}) =>
      SettingsState(
        dailyReminder: dailyReminder ?? this.dailyReminder,
        contestAlerts: contestAlerts ?? this.contestAlerts,
      );

  @override
  List<Object?> get props => [dailyReminder, contestAlerts];
}

class SettingsCubit extends Cubit<SettingsState> {
  static const _kDailyReminder = 'settings_daily_reminder';
  static const _kContestAlerts = 'settings_contest_alerts';

  final SharedPreferences _prefs;

  SettingsCubit(this._prefs) : super(_load(_prefs));

  static SettingsState _load(SharedPreferences prefs) => SettingsState(
        dailyReminder: prefs.getBool(_kDailyReminder) ?? true,
        contestAlerts: prefs.getBool(_kContestAlerts) ?? true,
      );

  Future<void> setDailyReminder(bool value) async {
    emit(state.copyWith(dailyReminder: value));
    await _prefs.setBool(_kDailyReminder, value);
  }

  Future<void> setContestAlerts(bool value) async {
    emit(state.copyWith(contestAlerts: value));
    await _prefs.setBool(_kContestAlerts, value);
  }
}
