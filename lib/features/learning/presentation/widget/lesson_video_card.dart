import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:lab_portal/core/theme/app_dimens.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entity/lesson_entity.dart';

/// An inline, tap-to-play video for a lesson. The network controller is only
/// created once the user taps play, so a page with several videos doesn't
/// buffer them all at once.
class LessonVideoCard extends StatefulWidget {
  final LessonVideo video;
  const LessonVideoCard({super.key, required this.video});

  @override
  State<LessonVideoCard> createState() => _LessonVideoCardState();
}

class _LessonVideoCardState extends State<LessonVideoCard> {
  VideoPlayerController? _controller;
  ChewieController? _chewie;
  bool _started = false;
  bool _failed = false;

  @override
  void dispose() {
    _chewie?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    setState(() => _started = true);
    final controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.video.url));
    try {
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _chewie = ChewieController(
          videoPlayerController: controller,
          autoPlay: true,
          looping: false,
          aspectRatio: controller.value.aspectRatio,
          materialProgressColors: ChewieProgressColors(
            playedColor: UiConstants.primaryButtonColor,
            handleColor: UiConstants.primaryButtonColor,
            bufferedColor: UiConstants.primaryButtonColor.withValues(alpha: 0.3),
            backgroundColor: Colors.white24,
          ),
        );
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _failed = true);
      await controller.dispose();
    }
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
                const Icon(Icons.play_lesson_outlined,
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
    if (_chewie != null) {
      return Chewie(controller: _chewie!);
    }
    if (_failed) {
      return const _Poster(
        icon: Icons.error_outline_rounded,
        label: "Couldn't load video",
      );
    }
    if (_started) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor:
              AlwaysStoppedAnimation<Color>(UiConstants.primaryButtonColor),
        ),
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
