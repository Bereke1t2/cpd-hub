import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/main/presentation/bloc/users_cubit.dart';
import 'package:cpd_hub/future/main/presentation/page/base_page.dart';
import 'package:cpd_hub/future/main/presentation/page/profile_page.dart';
import '../widget/user_box.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _sortBy = "Rating";

  @override
  void initState() {
    super.initState();
    context.read<UsersCubit>().loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      selectedIndex: 3,
      title: 'Community',
      subtitle: 'Connect with fellow coders',
      body: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return const Center(child: CircularProgressIndicator(color: UiConstants.primaryButtonColor));
          }
          if (state is UsersLoaded) {
            return _buildContent(state);
          }
          if (state is UsersError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.redAccent)));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(UsersLoaded state) {
    var users = state.users.where((u) => u.username.toLowerCase().contains(_searchQuery.toLowerCase()) || u.fullName.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    switch (_sortBy) {
      case 'Rating':
        users.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Name':
        users.sort((a, b) => a.fullName.compareTo(b.fullName));
        break;
      case 'Rank':
        users.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    // Top contributors: top 3 by rating
    final topContributors = List.of(users)..sort((a, b) => b.rating.compareTo(a.rating));

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Search members...",
                  hintStyle: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.4), fontSize: 13),
                  prefixIcon: const Icon(Icons.search_rounded, color: UiConstants.primaryButtonColor, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Sort controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['Rating', 'Name', 'Rank'].map((s) {
                final isSelected = _sortBy == s;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _sortBy = s),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? UiConstants.primaryButtonColor : Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? Colors.transparent : Colors.white10),
                      ),
                      child: Text(s, style: TextStyle(color: isSelected ? Colors.black : UiConstants.subtitleTextColor, fontWeight: FontWeight.w900, fontSize: 11)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Top Contributors
          if (topContributors.length >= 3) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                  const SizedBox(width: 10),
                  const Text("TOP CONTRIBUTORS", style: TextStyle(color: UiConstants.mainTextColor, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                ],
              ),
            ),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: topContributors.take(3).length,
                itemBuilder: (context, index) {
                  final u = topContributors[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(username: u.username),
                      ),
                    ),
                    child: Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: UiConstants.infoBackgroundColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: index == 0 ? Colors.amber.withOpacity(0.3) : UiConstants.borderColor.withOpacity(0.15)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: UiConstants.primaryButtonColor.withOpacity(0.2),
                            child: Text(u.fullName[0], style: const TextStyle(color: UiConstants.primaryButtonColor, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 8),
                          Text(u.username, style: const TextStyle(color: UiConstants.mainTextColor, fontWeight: FontWeight.w900, fontSize: 13), overflow: TextOverflow.ellipsis),
                          Text('Rating: ${u.rating}', style: TextStyle(color: UiConstants.getUserRatingColor(u.rating), fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],

          // All members
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: [
                Icon(Icons.people_rounded, color: UiConstants.primaryButtonColor, size: 18),
                const SizedBox(width: 10),
                Text("ALL MEMBERS (${users.length})".toUpperCase(), style: const TextStyle(color: UiConstants.mainTextColor, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              ],
            ),
          ),
          ...users.map((u) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: UserBox(
                  username: u.username,
                  bio: u.bio,
                  avatarUrl: u.avatarUrl,
                  rating: u.rating,
                  rank: u.solvedProblems,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(username: u.username),
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
