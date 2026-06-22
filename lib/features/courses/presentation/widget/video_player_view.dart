// Streams a YouTube video inline. Marks the lesson complete when the
// video reaches its end via onComplete().
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lab_portal/core/ui_constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerView extends StatefulWidget {
  final String url;
  final VoidCallback? onComplete;

  const VideoPlayerView({super.key, required this.url, this.onComplete});

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  YoutubePlayerController? _controller;
  StreamSubscription<YoutubePlayerValue>? _sub;
  String? _videoId;
  bool _completeFired = false;

  @override
  void initState() {
    super.initState();
    _videoId = YoutubePlayerController.convertUrlToId(widget.url);
    final id = _videoId;
    if (id != null) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: id,
        autoPlay: false,
        params: const YoutubePlayerParams(
          showFullscreenButton: true,
          strictRelatedVideos: true,
        ),
      );
      _sub = _controller!.listen(_onValue);
    }
  }

  void _onValue(YoutubePlayerValue value) {
    if (_completeFired) return;
    if (value.playerState == PlayerState.ended) {
      _completeFired = true;
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoId == null || _controller == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'This video is unavailable.',
            style: TextStyle(color: UiConstants.subtitleTextColor),
          ),
        ),
      );
    }
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
      child: RepaintBoundary(
        child: YoutubePlayer(
          controller: _controller!,
          aspectRatio: 16 / 9,
        ),
      ),
    );
  }
}
