import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/learning/roadmap_models.dart';
import 'package:cpd_hub/future/learning/presentation/bloc/roadmap_cubit.dart';
import 'package:cpd_hub/future/main/presentation/page/problem_details_page.dart';

class ModuleDetailPage extends StatelessWidget {
  final RoadmapModule module;

  const ModuleDetailPage({super.key, required this.module});

  static String? _youtubeId(String? url) {
    if (url == null || url.isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return null;
    }
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }
    return uri.queryParameters['v'];
  }

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    final done = context.watch<RoadmapCubit>().state.completedModuleIds.contains(module.moduleId);
    final yt = _youtubeId(module.videoUrl);

    return Scaffold(
      backgroundColor: UiConstants.infoBackgroundColor.withValues(alpha: 0.9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          module.title,
          style: TextStyle(fontSize: 16 * sc, fontWeight: FontWeight.w800),
        ),
        actions: [
          TextButton(
            onPressed: () => context.read<RoadmapCubit>().toggleModuleComplete(module.moduleId),
            child: Text(done ? 'Mark incomplete' : 'Mark done'),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16 * sc, 0, 16 * sc, 32 * sc),
        children: [
          if (module.videoUrl != null && module.videoUrl!.isNotEmpty) ...[
            Text('Watch', style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12 * sc, fontWeight: FontWeight.w700)),
            SizedBox(height: 8 * sc),
            Material(
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () async {
                  final u = Uri.parse(module.videoUrl!);
                  if (await canLaunchUrl(u)) {
                    await launchUrl(u, mode: LaunchMode.externalApplication);
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: yt != null
                          ? Image.network(
                              'https://img.youtube.com/vi/$yt/hqdefault.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.black26,
                                child: Icon(Icons.play_circle_filled_rounded, size: 56 * sc, color: Colors.white70),
                              ),
                            )
                          : Container(
                              color: Colors.black26,
                              child: Icon(Icons.play_circle_filled_rounded, size: 56 * sc, color: Colors.white70),
                            ),
                    ),
                    Icon(Icons.play_circle_fill_rounded, size: 64 * sc, color: Colors.white.withValues(alpha: 0.9)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20 * sc),
          ],
          Text(
            'Quick read',
            style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12 * sc, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8 * sc),
          MarkdownBody(
            data: module.markdownContent,
            styleSheet: MarkdownStyleSheet(
              h2: TextStyle(color: UiConstants.mainTextColor, fontSize: 18 * sc, fontWeight: FontWeight.w800),
              h1: TextStyle(color: UiConstants.mainTextColor, fontSize: 20 * sc, fontWeight: FontWeight.w900),
              p: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 14 * sc, height: 1.45),
              listBullet: TextStyle(color: UiConstants.primaryButtonColor, fontSize: 14 * sc),
              blockquote: TextStyle(color: Colors.tealAccent, fontSize: 13 * sc, fontStyle: FontStyle.italic),
              blockquoteDecoration: BoxDecoration(
                border: Border(left: BorderSide(color: UiConstants.primaryButtonColor, width: 3)),
              ),
            ),
          ),
          SizedBox(height: 24 * sc),
          Text(
            'Practice',
            style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 12 * sc, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 10 * sc),
          ...module.linkedProblems.map((p) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10 * sc),
              child: Material(
                color: UiConstants.infoBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => ProblemDetailsPage(
                          problemData: {
                            'title': p.title,
                            'difficulty': p.difficulty,
                            'problemId': p.problemId,
                            'tags': p.tags,
                            'likedCount': '—',
                            'dislikedCount': '—',
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(14 * sc),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.15)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.title,
                                style: TextStyle(
                                  color: UiConstants.mainTextColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14 * sc,
                                ),
                              ),
                              SizedBox(height: 4 * sc),
                              Text(
                                '${p.difficulty} · IDs sync with API later',
                                style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 11 * sc),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: UiConstants.subtitleTextColor),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
