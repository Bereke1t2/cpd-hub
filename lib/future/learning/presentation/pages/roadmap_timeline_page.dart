import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/learning/roadmap_models.dart';
import 'package:cpd_hub/future/learning/presentation/bloc/roadmap_cubit.dart';
import 'package:cpd_hub/future/main/presentation/page/base_page.dart';
import 'package:cpd_hub/future/learning/presentation/pages/module_detail_page.dart';

/// Vertical path of topic nodes for the selected roadmap.
class RoadmapTimelinePage extends StatelessWidget {
  const RoadmapTimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return BlocBuilder<RoadmapCubit, RoadmapState>(
      builder: (context, state) {
        final path = state.selectedRoadmap;
        if (path == null) {
          return BasePage(
            showBackButton: true,
            selectedIndex: 0,
            title: 'Roadmap',
            subtitle: '',
            body: Center(
              child: Text('No path selected', style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 14 * sc)),
            ),
          );
        }
        final progress = state.progressFor(path);

        return BasePage(
          showBackButton: true,
          selectedIndex: 0,
          title: path.title,
          subtitle: '${path.completedCount(state.completedModuleIds)} / ${path.totalModules} complete',
          body: ListView.builder(
            padding: EdgeInsets.fromLTRB(16 * sc, 8 * sc, 16 * sc, 100 * sc),
            itemCount: path.modules.length + 1,
            itemBuilder: (_, i) {
              if (i == 0) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16 * sc),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Overall progress', style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12 * sc)),
                      SizedBox(height: 8 * sc),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10 * sc,
                          backgroundColor: Colors.white10,
                          color: UiConstants.primaryButtonColor,
                        ),
                      ),
                    ],
                  ),
                );
              }
              final index = i - 1;
              final module = path.modules[index];
              final done = state.completedModuleIds.contains(module.moduleId);
              final isLast = index == path.modules.length - 1;
              return _TimelineNode(
                module: module,
                done: done,
                isLast: isLast,
                sc: sc,
                onOpen: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => BlocProvider.value(
                        value: context.read<RoadmapCubit>(),
                        child: ModuleDetailPage(module: module),
                      ),
                    ),
                  );
                },
                onToggleDone: () => context.read<RoadmapCubit>().toggleModuleComplete(module.moduleId),
              );
            },
          ),
        );
      },
    );
  }
}

class _TimelineNode extends StatelessWidget {
  final RoadmapModule module;
  final bool done;
  final bool isLast;
  final double sc;
  final VoidCallback onOpen;
  final VoidCallback onToggleDone;

  const _TimelineNode({
    required this.module,
    required this.done,
    required this.isLast,
    required this.sc,
    required this.onOpen,
    required this.onToggleDone,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28 * sc,
            child: Column(
              children: [
                Container(
                  width: 28 * sc,
                  height: 28 * sc,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done ? UiConstants.primaryButtonColor : Colors.white12,
                    border: Border.all(
                      color: done ? UiConstants.primaryButtonColor : UiConstants.borderColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    done ? Icons.check_rounded : Icons.circle_outlined,
                    size: 16 * sc,
                    color: done ? Colors.black : UiConstants.subtitleTextColor,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: EdgeInsets.symmetric(vertical: 4 * sc),
                      color: UiConstants.primaryButtonColor.withValues(alpha: 0.35),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 12 * sc),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20 * sc),
              child: Material(
                color: UiConstants.infoBackgroundColor,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: onOpen,
                  child: Padding(
                    padding: EdgeInsets.all(14 * sc),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                module.title,
                                style: TextStyle(
                                  color: UiConstants.mainTextColor,
                                  fontSize: 15 * sc,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: onToggleDone,
                              icon: Icon(
                                done ? Icons.undo_rounded : Icons.check_circle_outline_rounded,
                                color: done ? UiConstants.subtitleTextColor : UiConstants.primaryButtonColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          module.summaryLine,
                          style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12 * sc),
                        ),
                        SizedBox(height: 10 * sc),
                        Row(
                          children: [
                            Icon(Icons.article_outlined, size: 14 * sc, color: UiConstants.primaryButtonColor),
                            SizedBox(width: 6 * sc),
                            Text('Quick read', style: TextStyle(color: UiConstants.primaryButtonColor, fontSize: 11 * sc)),
                            SizedBox(width: 14 * sc),
                            if (module.videoUrl != null) ...[
                              Icon(Icons.play_circle_outline_rounded, size: 14 * sc, color: Colors.redAccent),
                              SizedBox(width: 6 * sc),
                              Text('Watch', style: TextStyle(color: Colors.redAccent, fontSize: 11 * sc)),
                            ],
                          ],
                        ),
                        SizedBox(height: 8 * sc),
                        Text(
                          '${module.linkedProblems.length} practice problems',
                          style: TextStyle(
                            color: UiConstants.subtitleTextColor.withValues(alpha: 0.7),
                            fontSize: 11 * sc,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
