import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/routing/route_names.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/app_text.dart';
import 'package:lab_portal/core/widgets/async_view.dart';
import 'package:lab_portal/core/widgets/avatar.dart';
import 'package:lab_portal/future/main/domain/entity/user_entity.dart';
import 'package:lab_portal/future/main/presentation/bloc/users/users_bloc.dart';

import 'base_page.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  // Division filter is purely a UI preference — keep it in local state.
  String _filterDivision = 'All';

  List<UserEntity> _applyDivisionFilter(List<UserEntity> users) {
    final list = _filterDivision == 'All'
        ? List<UserEntity>.from(users)
        : users.where((u) => u.division == _filterDivision).toList();
    // Leaderboard order: strongest first.
    list.sort((a, b) => b.rating.compareTo(a.rating));
    return list;
  }

  // Divisions are derived from the data so the filter always matches reality.
  List<String> _divisions(List<UserEntity> users) {
    final set = <String>{for (final u in users) u.division}..removeWhere((d) => d.isEmpty);
    final sorted = set.toList()..sort();
    return ['All', ...sorted];
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isEmpty ? 'U' : name.substring(0, name.length.clamp(1, 2)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UsersBloc>()..add(UsersStarted()),
      child: BasePage(
        selectedIndex: 4,
        title: 'Users',
        subtitle: 'Community leaderboard',
        body: Column(
          children: [
            // ── Search ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppDimens.lg, AppDimens.md, AppDimens.lg, AppDimens.sm),
              child: Builder(
                builder: (ctx) => Container(
                  height: AppDimens.buttonHeight,
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppDimens.md),
                  decoration: BoxDecoration(
                    color: UiConstants.infoBackgroundColor,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(AppDimens.rPill)),
                    border: Border.all(
                        color: UiConstants.primaryButtonColor
                            .withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded,
                          color: UiConstants.primaryButtonColor,
                          size: AppDimens.iconMd),
                      const SizedBox(width: AppDimens.sm),
                      Expanded(
                        child: TextField(
                          cursorColor: UiConstants.primaryButtonColor,
                          style: const TextStyle(
                              color: UiConstants.mainTextColor,
                              fontSize: AppDimens.fBody),
                          decoration: const InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            hintText: 'Search by name or username…',
                            hintStyle: TextStyle(
                                color: UiConstants.subtitleTextColor,
                                fontSize: AppDimens.fBody),
                          ),
                          onChanged: (q) =>
                              ctx.read<UsersBloc>().add(UsersSearchChanged(q)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Body ───────────────────────────────────────────────────────
            Expanded(
              child: BlocBuilder<UsersBloc, UsersState>(
                builder: (context, state) {
                  final users = state is UsersLoaded ? state.users : null;
                  return Column(
                    children: [
                      if (users != null && users.isNotEmpty)
                        _DivisionFilter(
                          divisions: _divisions(users),
                          selected: _filterDivision,
                          onSelected: (d) =>
                              setState(() => _filterDivision = d),
                        ),
                      Expanded(
                        child: AsyncView<List<UserEntity>>(
                          isLoading:
                              state is UsersLoading || state is UsersInitial,
                          error: state is UsersError ? state.message : null,
                          data: users == null
                              ? null
                              : _applyDivisionFilter(users),
                          isEmpty: (d) => d.isEmpty,
                          onRetry: () =>
                              context.read<UsersBloc>().add(UsersStarted()),
                          emptyMessage: 'No users found',
                          emptySubtitle:
                              'Try adjusting your search or division filter.',
                          builder: (list) => ListView.separated(
                            padding: const EdgeInsets.fromLTRB(AppDimens.lg,
                                AppDimens.sm, AppDimens.lg, AppDimens.xl + 80),
                            itemCount: list.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: AppDimens.sm),
                            itemBuilder: (context, index) => RepaintBoundary(
                              child: _UserTile(
                                rank: index + 1,
                                user: list[index],
                                initials: _initials(list[index].fullName.isEmpty
                                    ? list[index].username
                                    : list[index].fullName),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Division filter chips ─────────────────────────────────────────────────────
class _DivisionFilter extends StatelessWidget {
  final List<String> divisions;
  final String selected;
  final ValueChanged<String> onSelected;

  const _DivisionFilter({
    required this.divisions,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // SingleChildScrollView + Row: each chip sizes to its own content, so no
    // child is ever asked to fill the unbounded width of a horizontal list.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
      child: Row(
        children: [
          for (final d in divisions) ...[
            _chip(d),
            if (d != divisions.last) const SizedBox(width: AppDimens.sm),
          ],
        ],
      ),
    );
  }

  Widget _chip(String d) {
    final isActive = d == selected;
    return GestureDetector(
      onTap: () => onSelected(d),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.md, vertical: AppDimens.sm),
        decoration: BoxDecoration(
          color: isActive
              ? UiConstants.primaryButtonColor
              : UiConstants.infoBackgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.rPill)),
          border: Border.all(
            color: UiConstants.primaryButtonColor
                .withValues(alpha: isActive ? 1 : 0.25),
          ),
        ),
        child: Text(
          d == 'All' ? 'All' : 'Div $d',
          style: TextStyle(
            color: isActive ? Colors.white : UiConstants.subtitleTextColor,
            fontSize: AppDimens.fCaption,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Single user row ───────────────────────────────────────────────────────────
class _UserTile extends StatelessWidget {
  final int rank;
  final UserEntity user;
  final String initials;

  const _UserTile({
    required this.rank,
    required this.user,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    final isTop = rank <= 3;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        RouteNames.userDetails,
        arguments: user,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.md, vertical: AppDimens.md),
        decoration: BoxDecoration(
          color: UiConstants.infoBackgroundColor,
          borderRadius: AppDimens.brMd,
          border: Border.all(
            color: UiConstants.primaryButtonColor
                .withValues(alpha: isTop ? 0.45 : 0.16),
          ),
        ),
        child: Row(
          children: [
            // Rank
            SizedBox(
              width: 26,
              child: Text(
                '$rank',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isTop
                      ? UiConstants.primaryButtonColor
                      : UiConstants.subtitleTextColor,
                  fontSize: AppDimens.fH2,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: AppDimens.sm),
            Avatar(
              initials: initials,
              imageUrl: user.avatarUrl,
              size: AppDimens.avatarMd,
            ),
            const SizedBox(width: AppDimens.md),
            // Name + meta (single ellipsized line — overflow-proof on small screens)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.title(
                    user.fullName.isEmpty ? user.username : user.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimens.xxs),
                  AppText.caption(
                    '@${user.username} · ${user.solvedProblems} solved',
                    color: UiConstants.subtitleTextColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.sm),
            // Rating
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${user.rating}',
                  style: const TextStyle(
                    color: UiConstants.primaryButtonColor,
                    fontSize: AppDimens.fH1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                AppText.micro('rating',
                    color: UiConstants.subtitleTextColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
