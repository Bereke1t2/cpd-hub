import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_portal/core/di/injection.dart';
import 'package:lab_portal/core/routing/route_names.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:lab_portal/core/widgets/async_view.dart';
import 'package:lab_portal/future/main/domain/entity/user_entity.dart';
import 'package:lab_portal/future/main/presentation/bloc/users/users_bloc.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  // Division filter is purely a UI preference — keep it in local state.
  String _filterDivision = 'All';

  Color _ratingColor(int rating) {
    if (rating >= 2400) return const Color(0xFFFF0000);
    if (rating >= 2000) return const Color(0xFFFF8F00);
    if (rating >= 1900) return const Color(0xFF7E57C2);
    if (rating >= 1600) return const Color(0xFF1E88E5);
    if (rating >= 1400) return const Color(0xFF00BCD4);
    if (rating >= 1200) return const Color(0xFF43A047);
    return const Color(0xFF9E9E9E);
  }

  List<UserEntity> _applyDivisionFilter(List<UserEntity> users) {
    if (_filterDivision == 'All') return users;
    return users.where((u) => u.division == _filterDivision).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UsersBloc>()..add(UsersStarted()),
      child: Scaffold(
        backgroundColor: UiConstants.backgroundColor,
        appBar: AppBar(
          backgroundColor: UiConstants.primaryButtonColor,
          title: const Text('Users',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Builder(
                      builder: (ctx) => TextField(
                        decoration: InputDecoration(
                          hintText: 'Search users…',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: UiConstants.infoBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (q) =>
                            ctx.read<UsersBloc>().add(UsersSearchChanged(q)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: UiConstants.infoBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _filterDivision,
                        items: ['All', 'A', 'B', 'C', 'Div1', 'Div2']
                            .map((d) =>
                                DropdownMenuItem(value: d, child: Text(d)))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _filterDivision = v ?? 'All'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<UsersBloc, UsersState>(
                  builder: (context, state) => AsyncView<List<UserEntity>>(
                    isLoading: state is UsersLoading || state is UsersInitial,
                    error: state is UsersError ? state.message : null,
                    data: state is UsersLoaded
                        ? _applyDivisionFilter(state.users)
                        : null,
                    isEmpty: (d) => d.isEmpty,
                    onRetry: () => context.read<UsersBloc>().add(UsersStarted()),
                    emptyMessage: 'No users found',
                    emptySubtitle: 'Try adjusting your search or division filter.',
                    builder: (users) => LayoutBuilder(
                      builder: (context, constraints) {
                        final cross = constraints.maxWidth > 900
                            ? 3
                            : (constraints.maxWidth > 600 ? 2 : 1);
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: cross,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 3.6,
                          ),
                          itemCount: users.length,
                          itemBuilder: (context, index) =>
                              _userCard(context, users[index]),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userCard(BuildContext context, UserEntity u) {
    final color = _ratingColor(u.rating);
    final mini = List.generate(7, (i) => Random(u.rating + i).nextInt(6));
    final spark = List.generate(
        6, (i) => max(0, u.rating % 100 + Random(i).nextInt(30) - 10));

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        RouteNames.userDetails,
        arguments: u,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: UiConstants.infoBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: UiConstants.primaryButtonColor.withOpacity(0.04)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.12),
              child: Text(
                u.username
                    .substring(0, min(2, u.username.length))
                    .toUpperCase(),
                style:
                    TextStyle(color: color, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(children: [
                    Flexible(
                      child: Text(u.fullName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: UiConstants.mainTextColor)),
                    ),
                    const SizedBox(width: 8),
                    Text('@${u.username}',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 12)),
                  ]),
                  const SizedBox(height: 6),
                  Row(children: [
                    _miniHeat(mini),
                    const SizedBox(width: 8),
                    Expanded(
                        child: SizedBox(
                            height: 28,
                            child: _SmallSpark(values: spark))),
                  ]),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(u.rating.toString(),
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w900,
                        fontSize: 16)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(u.division,
                      style: TextStyle(
                          color: color, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniHeat(List<int> values) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: values.map((v) {
        final c = v <= 0
            ? Colors.transparent
            : (v == 1
                ? const Color(0xFFD7EAD9)
                : (v == 2
                    ? const Color(0xFFAEE0B3)
                    : (v == 3
                        ? const Color(0xFF86D28D)
                        : (v == 4
                            ? const Color(0xFF4FC068)
                            : const Color(0xFF2E8B3C)))));
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          width: 8,
          height: 8,
          decoration:
              BoxDecoration(color: c, borderRadius: BorderRadius.circular(2)),
        );
      }).toList(),
    );
  }
}

class _SmallSpark extends StatelessWidget {
  const _SmallSpark({required this.values});
  final List<int> values;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: const Size(double.infinity, double.infinity),
        painter: _SmallSparkPainter(values),
      );
}

class _SmallSparkPainter extends CustomPainter {
  _SmallSparkPainter(this.values);
  final List<int> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxV = values.reduce(max).toDouble();
    final minV = values.reduce(min).toDouble();
    final range = (maxV - minV) == 0 ? 1.0 : (maxV - minV);
    final paint = Paint()
      ..color = UiConstants.primaryButtonColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = (i / (values.length - 1)) * size.width;
      final y = size.height - ((values[i] - minV) / range) * size.height;
      if (i == 0) { path.moveTo(x, y); } else { path.lineTo(x, y); }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
