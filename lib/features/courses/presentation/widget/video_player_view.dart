// Wraps video_player + chewie. Isolated in RepaintBoundary.
// Auto-marks lesson complete at ≥90% watched via onComplete().
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  final String url;
  final VoidCallback? onComplete;

  const VideoPlayerView({super.key, required this.url, this.onComplete});

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  VideoPlayerController? _vpc;
  ChewieController? _cc;
  bool _completeFired = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final vpc =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await vpc.initialize();
    vpc.addListener(_onTick);
    final cc = ChewieController(
      videoPlayerController: vpc,
      autoPlay: false,
      looping: false,
    );
    if (mounted) setState(() { _vpc = vpc; _cc = cc; });
  }

  void _onTick() {
    if (_completeFired) return;
    final dur = _vpc?.value.duration;
    final pos = _vpc?.value.position;
    if (dur == null || pos == null || dur.inMilliseconds == 0) return;
    if (pos.inMilliseconds / dur.inMilliseconds >= 0.9) {
      _completeFired = true;
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _vpc?.removeListener(_onTick);
    _cc?.dispose();
    _vpc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cc == null) {
      return const Center(
        child: CircularProgressIndicator(
            color: UiConstants.primaryButtonColor),
      );
    }
    return RepaintBoundary(child: Chewie(controller: _cc!));
  }
}
