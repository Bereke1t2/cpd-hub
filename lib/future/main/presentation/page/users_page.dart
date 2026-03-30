import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
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
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = "";
  String _sortBy = "Rating";

  @override
  void initState() {
    super.initState();
    context.read<UsersCubit>().loadUsers();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<UsersCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
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
            return _buildContent(context, state, sc);
          }
          if (state is UsersError) {
            return Center(child: Text(state.message, style: TextStyle(color: Colors.redAccent, fontSize: 14 * sc)));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, UsersLoaded state, double sc) {
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

    final topContributors = List.of(users)..sort((a, b) => b.rating.compareTo(a.rating));

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 14 * sc),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16 * sc),
            child: Container(
              height: 44 * sc,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: TextStyle(color: Colors.white, fontSize: 14 * sc),
                decoration: InputDecoration(
                  hintText: "Search members...",
                  hintStyle: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.4), fontSize: 13 * sc),
                  prefixIcon: Icon(Icons.search_rounded, color: UiConstants.primaryButtonColor, size: 20 * sc),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16 * sc, vertical: 13 * sc),
                ),
              ),
            ),
          ),
          SizedBox(height: 12 * sc),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16 * sc),
            child: Row(
              children: ['Rating', 'Name', 'Rank'].map((s) {
                final isSelected = _sortBy == s;
                return Padding(
                  padding: EdgeInsets.only(right: 10 * sc),
                  child: GestureDetector(
                    onTap: () => setState(() => _sortBy = s),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14 * sc, vertical: 8 * sc),
                      decoration: BoxDecoration(
                        color: isSelected ? UiConstants.primaryButtonColor : Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? Colors.transparent : Colors.white10),
                      ),
                      child: Text(s, style: TextStyle(color: isSelected ? Colors.black : UiConstants.subtitleTextColor, fontWeight: FontWeight.w800, fontSize: 12 * sc)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20 * sc),

          if (topContributors.length >= 3) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(16 * sc, 0, 16 * sc, 12 * sc),
              child: Row(
                children: [
                  Icon(Icons.star_rounded, color: Colors.amber, size: 18 * sc),
                  SizedBox(width: 8 * sc),
                  Text("TOP CONTRIBUTORS", style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.7), fontSize: 12 * sc, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                ],
              ),
            ),
            SizedBox(
              height: 125 * sc,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16 * sc),
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
                      width: 120 * sc,
                      margin: EdgeInsets.only(right: 10 * sc),
                      padding: EdgeInsets.all(12 * sc),
                      decoration: BoxDecoration(
                        color: UiConstants.infoBackgroundColor.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: index == 0 ? Colors.amber.withValues(alpha: 0.25) : UiConstants.borderColor.withValues(alpha: 0.12)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 18 * sc,
                            backgroundColor: UiConstants.primaryButtonColor.withValues(alpha: 0.2),
                            child: Text(u.fullName[0], style: TextStyle(color: UiConstants.primaryButtonColor, fontWeight: FontWeight.w700, fontSize: 14 * sc)),
                          ),
                          SizedBox(height: 8 * sc),
                          Text(u.username, style: TextStyle(color: UiConstants.mainTextColor, fontWeight: FontWeight.w700, fontSize: 12 * sc), overflow: TextOverflow.ellipsis),
                          SizedBox(height: 2 * sc),
                          Text('${u.rating}', style: TextStyle(color: UiConstants.getUserRatingColor(u.rating), fontSize: 11 * sc, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20 * sc),
          ],

          Padding(
            padding: EdgeInsets.fromLTRB(16 * sc, 0, 16 * sc, 12 * sc),
            child: Row(
              children: [
                Icon(Icons.people_rounded, color: UiConstants.primaryButtonColor, size: 18 * sc),
                SizedBox(width: 8 * sc),
                Text("ALL MEMBERS (${users.length})".toUpperCase(), style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.7), fontSize: 12 * sc, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
              ],
            ),
          ),
          ...users.map((u) => UserBox(
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
              )),
          if (state.isLoadingMore)
            Padding(
              padding: EdgeInsets.all(16 * sc),
              child: const Center(child: CircularProgressIndicator(color: UiConstants.primaryButtonColor, strokeWidth: 2)),
            ),
          if (!state.hasMore && users.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(16 * sc),
              child: Center(
                child: Text(
                  'All members loaded',
                  style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.5), fontSize: 12 * sc),
                ),
              ),
            ),
          SizedBox(height: 80 * sc),
        ],
      ),
    );
  }
}
