import 'package:flutter/material.dart';

import 'youtube_web_player_state.dart';

class YoutubeWebPlayerController extends ValueNotifier<YoutubeWebPlayerState> {
  Function()? pause;
  Function()? play;
  Function(Duration duration)? seekTo;
  Function(double speed)? setPlaybackSpeed;
  late String videoId;

  bool isDisposed = false;

  YoutubeWebPlayerController(super.value);

  static YoutubeWebPlayerController getController(String videoId) {
    final controller = YoutubeWebPlayerController(
      YoutubeWebPlayerState(
        Duration.zero,
        Duration.zero,
        false,
      ),
    );
    controller.videoId = videoId;
    return controller;
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
