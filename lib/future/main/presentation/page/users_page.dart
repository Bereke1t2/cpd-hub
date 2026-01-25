import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/users/users_bloc.dart';
import 'package:lab_portal/future/main/presentation/di/main_di.dart';
import 'package:lab_portal/future/main/presentation/page/base_page.dart';
import 'package:lab_portal/future/main/presentation/widget/search.dart';
import 'package:lab_portal/future/main/presentation/widget/user_box.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainDI.buildUsersBloc()..add(UsersStarted()),
      child: BasePage(
        title: "Users",
        subtitle: "Explore and connect with users",
        selectedIndex: 3,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final isWide = maxWidth >= 900;
            final contentWidth = isWide ? 980.0 : maxWidth;

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Column(
                  children: [
                    BlocBuilder<UsersBloc, UsersState>(
                      buildWhen: (p, c) => c is UsersLoaded || c is UsersInitial,
                      builder: (context, state) {
                        return SearchBox(
                          hintText: 'Search users...',
                          onChanged: (value) => context
                              .read<UsersBloc>()
                              .add(UsersSearchChanged(value)),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: BlocBuilder<UsersBloc, UsersState>(
                        builder: (context, state) {
                          if (state is UsersLoading || state is UsersInitial) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is UsersError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(state.message),
                              ),
                            );
                          }

                          final users = (state as UsersLoaded).users;

                          if (users.isEmpty) {
                            return const Center(child: Text('No users found'));
                          }

                          if (isWide) {
                            return GridView.builder(
                              padding: const EdgeInsets.fromLTRB(8, 6, 8, 14),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 3.35,
                              ),
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                return UserBox(
                                  username: user.username,
                                  bio: user.bio,
                                  avatarUrl: user.avatarUrl,
                                  rating: user.rating,
                                  rank: int.tryParse(user.rank) ?? 0,
                                  onTap: () {},
                                );
                              },
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.only(top: 2, bottom: 12),
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return UserBox(
                                username: user.username,
                                bio: user.bio,
                                avatarUrl: user.avatarUrl,
                                rating: user.rating,
                                rank: int.tryParse(user.rank) ?? 0,
                                onTap: () {},
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
