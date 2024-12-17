import 'package:flutter/material.dart';
import 'youtube_web_player_state.dart';

/// Controller for managing the state of the YouTube Web Player.
class YoutubeWebPlayerController extends ValueNotifier<YoutubeWebPlayerState> {
  /// Function to pause the video.
  Function()? pause;

  /// Function to play the video.
  Function()? play;

  /// Function to seek to a specific duration in the video.
  Function(Duration duration)? seekTo;

  /// Function to set the playback speed of the video.
  Function(double speed)? setPlaybackSpeed;

  /// The ID of the YouTube video.
  late String videoId;

  /// Indicates whether the controller has been disposed.
  bool isDisposed = false;

  /// Constructor that initializes the controller with an initial value.
  YoutubeWebPlayerController(super.value);

  /// Factory method to create a new controller instance with the given video ID.
  static YoutubeWebPlayerController getController(String videoId) {
    final controller = YoutubeWebPlayerController(
      YoutubeWebPlayerState(
        Duration.zero, // Initial position of the video.
        Duration.zero, // Total duration of the video.
        false, // Whether the video is currently playing.
      ),
    );
    controller.videoId = videoId; // Set the video ID for the controller.
    return controller;
  }

  /// Dispose method overrides to handle cleaning up resources.
  @override
  void dispose() {
    isDisposed = true; // Mark the controller as disposed.
    super.dispose(); // Call the superclass dispose method.
  }
}
