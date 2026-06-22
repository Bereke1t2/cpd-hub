import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../domain/entity/lesson_entity.dart';

/// An inline, tap-to-play YouTube video for a lesson. The player (a webview)
/// is only created once the user taps play, so a page with several videos
/// doesn't spin up multiple webviews at once.
class LessonVideoCard extends StatefulWidget {
  final LessonVideo video;
  const LessonVideoCard({super.key, required this.video});

  @override
  State<LessonVideoCard> createState() => _LessonVideoCardState();
}

class _LessonVideoCardState extends State<LessonVideoCard> {
  YoutubePlayerController? _controller;
  String? _videoId;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _videoId = YoutubePlayerController.convertUrlToId(widget.video.url);
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  void _start() {
    final id = _videoId;
    if (id == null) return;
    _controller = YoutubePlayerController.fromVideoId(
      videoId: id,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        strictRelatedVideos: true,
      ),
    );
    setState(() => _started = true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppDimens.brMd,
        border: Border.all(
            color: UiConstants.primaryButtonColor.withValues(alpha: 0.16)),
        color: Colors.black,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _buildStage(),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimens.sm),
            child: Row(
              children: [
                const Icon(Icons.smart_display_outlined,
                    size: AppDimens.iconSm,
                    color: UiConstants.primaryButtonColor),
                const SizedBox(width: AppDimens.sm),
                Expanded(
                  child: Text(
                    widget.video.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: UiConstants.mainTextColor,
                      fontSize: AppDimens.fBody,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (widget.video.durationLabel != null)
                  Text(
                    widget.video.durationLabel!,
                    style: const TextStyle(
                      color: UiConstants.subtitleTextColor,
                      fontSize: AppDimens.fCaption,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStage() {
    if (_started && _controller != null) {
      // Green-themed YouTube controls to match the app.
      return Theme(
        data: Theme.of(context).copyWith(
          extensions: const [
            YoutubePlayerTheme(
              progressBarActiveColor: UiConstants.primaryButtonColor,
              progressBarBufferedColor: UiConstants.subtitleTextColor,
              controlsColor: Colors.white,
            ),
          ],
        ),
        child: YoutubePlayer(
          controller: _controller!,
          aspectRatio: 16 / 9,
        ),
      );
    }
    if (_videoId == null) {
      return const _Poster(
        icon: Icons.error_outline_rounded,
        label: 'Video unavailable',
      );
    }
    return GestureDetector(
      onTap: _start,
      child: const _Poster(
        icon: Icons.play_circle_fill_rounded,
        label: 'Tap to play',
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Poster({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            UiConstants.primaryButtonColor.withValues(alpha: 0.18),
            Colors.black,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 52, color: UiConstants.primaryButtonColor),
          const SizedBox(height: AppDimens.xs),
          Text(
            label,
            style: const TextStyle(
              color: UiConstants.mainTextColor,
              fontSize: AppDimens.fCaption,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
