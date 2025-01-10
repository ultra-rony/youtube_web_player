import 'package:flutter/material.dart';

/// Controller for managing the state of the YouTube Web Player.
class YoutubeWebPlayerController extends ChangeNotifier {
  /// Function to pause the video playback.
  Function() _pause = () {};
  Function() get pause => _pause;

  /// Function to start video playback.
  Function() _play = () {};
  Function() get play => _play;

  /// Function to seek to a specific time in the video.
  Function(Duration duration) _seekTo = (Duration duration) {};
  Function(Duration duration) get seekTo => _seekTo;

  /// Function to set the playback speed of the video.
  Function(double speed) _setPlaybackSpeed = (double speed) {};
  Function(double speed) get setPlaybackSpeed => _setPlaybackSpeed;

  /// ID of the YouTube video currently being played.
  String? _videoId;
  String? get videoId => _videoId;

  /// Indicates whether the controller has been disposed of.
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  /// Duration of the video.
  Duration _duration = Duration.zero;
  Duration get duration => _duration;

  /// Current position of the video playback.
  Duration _position = Duration.zero;
  Duration get position => _position;

  /// Indicates if the video is currently playing.
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  /// Indicates if the video player is ready to play.
  bool _isReady = false;
  bool get isReady => _isReady;

  /// Constructor that initializes the controller without any initial values.
  YoutubeWebPlayerController();

  /// Method to set the video ID for the controller.
  void setVideoId(String videoId) {
    _videoId = videoId;
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
    _duration = duration;
    // Update the current playback position.
    _position = position;
    // Update the play status.
    _isPlaying = isPlaying;
    // Notify listeners about state changes.
    notifyListeners();
  }

  /// Method to set the readiness status of the player.
  void setIsReady(bool isReady) {
    _isReady = isReady;
    notifyListeners();
  }

  /// Method to mark the controller as disposed.
  void setIsDisposed(bool isDisposed) {
    _isDisposed = isDisposed;
    notifyListeners();
  }

  /// Method to set the functions for controlling the player.
  void setMethods({
    required Function() pause,
    required Function() play,
    required Function(Duration duration) seekTo,
    required Function(double speed) setPlaybackSpeed,
  }) {
    /// Set the pause function.
    _pause = pause;

    /// Set the play function.
    _play = play;

    /// Set the seek function.
    _seekTo = seekTo;

    /// Set the playback speed function.
    _setPlaybackSpeed = setPlaybackSpeed;

    /// Notify listeners that the methods have changed.
    notifyListeners();
  }
}
