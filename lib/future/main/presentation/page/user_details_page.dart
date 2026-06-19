import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/future/main/domain/entity/user_entity.dart';

/// Minimal scaffold — to be built out in Phase 6.
class UserDetailsPage extends StatelessWidget {
  final UserEntity user;
  const UserDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: UiConstants.primaryButtonColor,
        title: Text('@${user.username}'),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          user.fullName,
          style: const TextStyle(
            color: UiConstants.mainTextColor,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
