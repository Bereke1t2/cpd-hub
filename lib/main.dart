import 'package:flutter/material.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/routing/app_router.dart';
import 'package:lab_portal/core/routing/route_names.dart';
import 'core/ui_constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPD Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: UiConstants.primaryButtonColor,
        useMaterial3: true,
      ),
      initialRoute: RouteNames.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
