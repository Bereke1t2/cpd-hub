import 'package:flutter/material.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import 'package:lab_portal/future/main/presentation/widget/search.dart';
import 'package:lab_portal/future/main/presentation/widget/user_box.dart';

class UsersPage extends StatelessWidget {
  final List<Map<String, String>> users = [
    {
      'username': 'smartguy',
      'bio': 'I am the smartest guy',
      'avatarUrl': 'https://example.com/avatar.jpg',
      'rating': '2900',
      'rank': '1',
    },
    {
      'username': 'codewizard',
      'bio': 'Passionate about clean architecture and open-source.',
      'avatarUrl': 'https://example.com/avatar2.jpg',
      'rating': '2750',
      'rank': '2',
    },
    {
      'username': 'devops_ninja',
      'bio': 'Automating deployments and scaling infrastructure.',
      'avatarUrl': 'https://example.com/avatar3.jpg',
      'rating': '1500',
      'rank': '3',
    },
    {
      'username': 'ui_guru',
      'bio': 'Design systems advocate and Flutter UI craftsman.',
      'avatarUrl': 'https://example.com/avatar4.jpg',
      'rating': '3400',
      'rank': '4',
    },
    {
      'username': 'data_cruncher',
      'bio': 'ML enthusiast turning data into insights.',
      'avatarUrl': 'https://example.com/avatar5.jpg',
      'rating': '800',
      'rank': '5',
    },
    {
      'username': 'bug_hunter',
      'bio': 'Relentless at finding edge cases and race conditions.',
      'avatarUrl': 'https://example.com/avatar6.jpg',
      'rating': '2400',
      'rank': '6',
    },
    {
      'username': 'async_master',
      'bio': 'Concurrency, isolates, and streams fanatic.',
      'avatarUrl': 'https://example.com/avatar7.jpg',
      'rating': '1200',
      'rank': '7',
    },
    {
      'username': 'security_sage',
      'bio': 'Securing APIs and hardening apps.',
      'avatarUrl': 'https://example.com/avatar8.jpg',
      'rating': '10',
      'rank': '8',
    },
    {
      'username': 'test_writer',
      'bio': 'TDD believer. Tests before coffee.',
      'avatarUrl': 'https://example.com/avatar9.jpg',
      'rating': '2350',
      'rank': '9',
    },
    {
      'username': 'perf_tuner',
      'bio': 'Micro-optimizations that add up.',
      'avatarUrl': 'https://example.com/avatar10.jpg',
      'rating': '2525',
      'rank': '10',
    },
    {
      'username': 'fullstack_alex',
      'bio': 'Bridging frontend and backend worlds.',
      'avatarUrl': 'https://example.com/avatar11.jpg',
      'rating': '2700',
      'rank': '11',
    },
    {
      'username': 'package_builder',
      'bio': 'Publishing reusable Dart & Flutter packages.',
      'avatarUrl': 'https://example.com/avatar12.jpg',
      'rating': '2450',
      'rank': '12',
    }

  ];
  UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Users",
      subtitle: "Explore and connect with users",
      selectedIndex: 3,
      body: Column(
        children: [
          SearchBox(hintText: 'Search users...', onChanged: (value) {
            // Handle search logic here
          }),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(users.length, (index) {
                  final user = users[index];
                  return UserBox(
                    username: user['username']!,
                    bio: user['bio']!,
                    avatarUrl: user['avatarUrl']!,
                    rating: int.tryParse(user['rating']!) ?? 0,
                    rank: int.tryParse(user['rank']!) ?? 0,
                    onTap: () {
                      // Handle user box tap
                    },
                  );
                }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
