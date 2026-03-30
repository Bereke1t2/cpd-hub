import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/learning/presentation/bloc/roadmap_cubit.dart';
import 'package:cpd_hub/future/main/presentation/page/base_page.dart';
import 'package:cpd_hub/future/learning/presentation/pages/roadmap_timeline_page.dart';

class RoadmapPathsPage extends StatelessWidget {
  const RoadmapPathsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return BasePage(
      showBackButton: true,
      selectedIndex: 0,
      title: 'Curriculum',
      subtitle: 'Pick a learning path',
      body: BlocBuilder<RoadmapCubit, RoadmapState>(
        builder: (context, state) {
          if (state.roadmaps.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: UiConstants.primaryButtonColor));
          }
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(16 * sc, 12 * sc, 16 * sc, 100 * sc),
            itemCount: state.roadmaps.length,
            itemBuilder: (_, i) {
              final path = state.roadmaps[i];
              final progress = state.progressFor(path);
              return Padding(
                padding: EdgeInsets.only(bottom: 12 * sc),
                child: Material(
                  color: UiConstants.infoBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      context.read<RoadmapCubit>().selectRoadmap(path.roadmapId);
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(builder: (_) => const RoadmapTimelinePage()),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16 * sc),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10 * sc, vertical: 4 * sc),
                                decoration: BoxDecoration(
                                  color: UiConstants.primaryButtonColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  path.difficultyLevel,
                                  style: TextStyle(
                                    color: UiConstants.primaryButtonColor,
                                    fontSize: 11 * sc,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10 * sc),
                          Text(
                            path.title,
                            style: TextStyle(
                              color: UiConstants.mainTextColor,
                              fontSize: 17 * sc,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 6 * sc),
                          Text(
                            path.description,
                            style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12 * sc, height: 1.35),
                          ),
                          SizedBox(height: 14 * sc),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 6 * sc,
                                    backgroundColor: Colors.white12,
                                    color: UiConstants.primaryButtonColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12 * sc),
                              Text(
                                '${(progress * 100).round()}%',
                                style: TextStyle(
                                  color: UiConstants.primaryButtonColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12 * sc,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6 * sc),
                          Text(
                            '${path.completedCount(state.completedModuleIds)} / ${path.totalModules} topics',
                            style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 11 * sc),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
