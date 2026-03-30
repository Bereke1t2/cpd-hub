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
      backgroundColor: UiConstants.backgroundColor,
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
            Text('VIDEO LECTURE', style: TextStyle(color: UiConstants.primaryButtonColor, fontSize: 12 * sc, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
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
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  'https://img.youtube.com/vi/$yt/hqdefault.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: UiConstants.primaryButtonColor.withValues(alpha: 0.1),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withValues(alpha: 0.4),
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.6),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              color: Colors.black26,
                              child: Icon(Icons.play_circle_filled_rounded, size: 56 * sc, color: Colors.white70),
                            ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8 * sc),
                      decoration: BoxDecoration(
                        color: UiConstants.primaryButtonColor.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: UiConstants.primaryButtonColor.withValues(alpha: 0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(Icons.play_arrow_rounded, size: 48 * sc, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20 * sc),
          ],
          Container(
            padding: EdgeInsets.all(16 * sc),
            decoration: BoxDecoration(
              color: UiConstants.infoBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LESSON NOTES',
                  style: TextStyle(color: UiConstants.primaryButtonColor, fontSize: 12 * sc, letterSpacing: 1.2, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12 * sc),
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
              ],
            ),
          ),
          SizedBox(height: 24 * sc),
          Text(
            'PRACTICE PROBLEMS',
            style: TextStyle(color: UiConstants.primaryButtonColor, fontSize: 12 * sc, letterSpacing: 1.2, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10 * sc),
          ...module.linkedProblems.map((p) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10 * sc),
              child: Material(
                color: UiConstants.infoBackgroundColor,
                child: InkWell(
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
                      border: Border.all(color: UiConstants.primaryButtonColor.withValues(alpha: 0.3)),
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
                                p.difficulty,
                                style: TextStyle(
                                  color: UiConstants.primaryButtonColor.withValues(alpha: 0.9), 
                                  fontSize: 12 * sc,
                                  fontWeight: FontWeight.w600,
                                ),
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
