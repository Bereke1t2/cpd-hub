import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/routing/app_router.dart';
import 'package:lab_portal/core/routing/route_names.dart';
import 'package:lab_portal/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:lab_portal/features/settings/presentation/page/settings_page.dart';

void main() {
  group('SettingsCubit', () {
    test('defaults to enabled when nothing is stored', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final cubit = SettingsCubit(prefs);
      expect(cubit.state.dailyReminder, isTrue);
      expect(cubit.state.contestAlerts, isTrue);
    });

    test('toggling persists across cubit re-creation', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final cubit = SettingsCubit(prefs);
      await cubit.setDailyReminder(false);
      await cubit.setContestAlerts(false);
      expect(cubit.state.dailyReminder, isFalse);
      expect(cubit.state.contestAlerts, isFalse);

      // A fresh cubit reading the same prefs should see the saved values.
      final reloaded = SettingsCubit(prefs);
      expect(reloaded.state.dailyReminder, isFalse);
      expect(reloaded.state.contestAlerts, isFalse);
    });

    test('loads stored values on init', () async {
      SharedPreferences.setMockInitialValues({
        'settings_daily_reminder': false,
        'settings_contest_alerts': true,
      });
      final prefs = await SharedPreferences.getInstance();
      final cubit = SettingsCubit(prefs);
      expect(cubit.state.dailyReminder, isFalse);
      expect(cubit.state.contestAlerts, isTrue);
    });
  });

  group('Settings page', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      if (getIt.isRegistered<SettingsCubit>()) {
        getIt.unregister<SettingsCubit>();
      }
      getIt.registerLazySingleton<SettingsCubit>(() => SettingsCubit(prefs));
    });

    testWidgets('the /settings route renders the SettingsPage', (tester) async {
      // Tall viewport so the whole (lazy) settings list builds.
      tester.view.physicalSize = const Size(1000, 2600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final route = AppRouter.onGenerateRoute(
        const RouteSettings(name: RouteNames.settings),
      ) as MaterialPageRoute;

      await tester.pumpWidget(
        MaterialApp(home: Builder(builder: route.builder)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Sign out'), findsOneWidget);
    });

    testWidgets('toggling a switch persists through the cubit',
        (tester) async {
      tester.view.physicalSize = const Size(1000, 2600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));
      await tester.pumpAndSettle();

      final firstSwitch = find.byType(Switch).first;
      expect(tester.widget<Switch>(firstSwitch).value, isTrue);

      await tester.tap(firstSwitch);
      await tester.pump();

      expect(getIt<SettingsCubit>().state.dailyReminder, isFalse);
      expect(tester.widget<Switch>(firstSwitch).value, isFalse);
    });
  });
}
