import 'package:flutter/material.dart';
import 'future/main/presentation/page/contest_page.dart';
import 'future/main/presentation/page/home_page.dart';
import 'future/main/presentation/page/problems_page.dart';
import 'future/main/presentation/page/profile_page.dart';
import 'future/main/presentation/page/users_page.dart';

class LabPortalApp extends StatelessWidget {
  const LabPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const HomePage(),
        '/problems': (context) => ProblemsPage(),
        '/contests': (context) => ContestPage(),
        '/profile': (context) => const ProfilePage(),
        '/users': (context) => UsersPage(),
      },
      initialRoute: '/',
    );
  }
}

void main() {
  runApp(const LabPortalApp());
}