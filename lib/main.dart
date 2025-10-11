import 'package:flutter/material.dart';
import 'future/main/presentation/page/contest_page.dart';
import 'future/main/presentation/page/home_page.dart';
import 'future/main/presentation/page/problems_page.dart';
import 'future/main/presentation/page/profile_page.dart';
import 'future/main/presentation/page/users_page.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => HomePage(),
      '/problems': (context) => ProblemsPage(),
      '/contests': (context) => ContestPage(),
      '/profile': (context) => ProfilePage(),
      '/users': (context) => UsersPage(),
    },
    initialRoute: '/',
  ));
}