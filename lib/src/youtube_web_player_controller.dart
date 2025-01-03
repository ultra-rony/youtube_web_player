import 'package:flutter/material.dart';

/// Controller for managing the state of the YouTube Web Player.
class YoutubeWebPlayerController extends ChangeNotifier {
  /// Function to pause the video playback.
  Function() pause = () {};

  /// Function to start video playback.
  Function() play = () {};

  /// Function to seek to a specific time in the video.
  Function(Duration duration) seekTo = (Duration duration) {};

  /// Function to set the playback speed of the video.
  Function(double speed) setPlaybackSpeed = (double speed) {};

  /// ID of the YouTube video currently being played.
  String? videoId;

  /// Indicates whether the controller has been disposed of.
  bool isDisposed = false;

  /// Duration of the video.
  Duration duration = Duration.zero;

  /// Current position of the video playback.
  Duration position = Duration.zero;

  /// Indicates if the video is currently playing.
  bool isPlaying = false;

  /// Indicates if the video player is ready to play.
  bool isReady = false;

  /// Constructor that initializes the controller without any initial values.
  YoutubeWebPlayerController();

  /// Method to set the video ID for the controller.
  void setVideoId(String videoId) {
    this.videoId = videoId;
    // Notify listeners that video ID has changed.
    notifyListeners();
  }

  /// Method to update the player state (position, duration, and play status).
  void setPlayerState({
    required Duration duration,
    required Duration position,
    required bool isPlaying,
  }) {
    // Update the video duration.
    this.duration = duration;
    // Update the current playback position.
    this.position = position;
    // Update the play status.
    this.isPlaying = isPlaying;
    // Notify listeners about state changes.
    notifyListeners();
  }

  /// Method to set the readiness status of the player.
  void setIsReady(bool isReady) {
    this.isReady = isReady;
    notifyListeners();
  }

  /// Method to mark the controller as disposed.
  void setIsDisposed(bool isDisposed) {
    this.isDisposed = isDisposed;
    notifyListeners();
  }

  /// Method to set the functions for controlling the player.
  void setMethods({
    required Function() pause,
    required Function() play,
    required Function(Duration duration) seekTo,
    required Function(double speed) setPlaybackSpeed,
  }) {
    // Set the pause function.
    this.pause = pause;
    // Set the play function.
    this.play = play;
    // Set the seek function.
    this.seekTo = seekTo;
    // Set the playback speed function.
    this.setPlaybackSpeed = setPlaybackSpeed;
    // Notify listeners that the methods have changed.
    notifyListeners();
  }

  /// Dispose method to clean up resources when the controller is no longer needed.
  @override
  void dispose() {
    // Mark the controller as disposed.
    setIsDisposed(true);
    super.dispose();
  }
}
