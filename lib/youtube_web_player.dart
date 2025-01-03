import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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

/// A widget that displays a YouTube video using an embedded WebView.
class YoutubeWebPlayer extends StatefulWidget {
  const YoutubeWebPlayer({
    super.key,
    // Unique ID for the YouTube video to be played.
    required this.videoId,
    // Optional custom controller for the player.
    this.controller,
    // Allow fullscreen for iframe.
    this.isIframeAllowFullscreen = false,
    // Allow inline playback.
    this.isAllowsInlineMediaPlayback = true,
  });

  // The player controller, can be null.
  final YoutubeWebPlayerController? controller;

  // The ID of the YouTube video to play.
  final String videoId;

  // Indicates if fullscreen is allowed.
  final bool isIframeAllowFullscreen;

  // Indicates if inline playback is allowed.
  final bool isAllowsInlineMediaPlayback;

  @override
  State<YoutubeWebPlayer> createState() => _YoutubeWebPlayerState();
}

class _YoutubeWebPlayerState extends State<YoutubeWebPlayer>
    with AutomaticKeepAliveClientMixin {
  // Controller for the InAppWebView.
  InAppWebViewController? _inAppWebViewController;

  // Timer to periodically check the state of the video.
  Timer? _getStateInterval;

  // Controller for video playback state.
  YoutubeWebPlayerController? _youtubeWebPlayerController;

  // Variable to hold the loaded HTML content
  String? htmlContent;

  // Keeps the state alive when switching tabs.
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Call loadData to initialize the player and video state.
    loadData();
  }

  @override
  void dispose() {
    // Clean up resources on widget disposal.
    // Dispose the player controller.
    _youtubeWebPlayerController?.dispose();
    // Dispose the WebView controller.
    _inAppWebViewController?.dispose();
    // Cancel the state checking timer.
    _getStateInterval?.cancel();
    super.dispose();
  }

  /// Method to load video state periodically.
  loadData() {
    // Use the provided controller or instantiate a new one.
    _youtubeWebPlayerController =
        widget.controller ?? YoutubeWebPlayerController();

    // Set the video ID for the controller.
    _youtubeWebPlayerController?.setVideoId(widget.videoId);

    // Set the methods for controlling the player.
    _youtubeWebPlayerController?.setMethods(
      pause: _onPause,
      play: _onPlay,
      seekTo: _onSeekTo,
      setPlaybackSpeed: _onSetPlaybackSpeed,
    );

    // Start a timer to check the state of the video every second.
    _getStateInterval = Timer.periodic(const Duration(seconds: 1), (res) async {
      if (!mounted) {
        return; // Exit if the widget is not mounted.
      }
      // Evaluate JavaScript to get the current state of the video.
      final response = await _inAppWebViewController?.evaluateJavascript(
          source: "getState()");
      if (response != null) {
        // Create a map to hold state values.
        final stateMap = <String, dynamic>{};
        for (final entry in response.entries) {
          stateMap[entry.key.toString()] =
              entry.value.toString(); // Convert response to map.
        }
        // Update the controller state if values are valid.
        if (double.tryParse(stateMap['position'].toString()) != null &&
            double.tryParse(stateMap['duration'].toString()) != null &&
            bool.tryParse(stateMap['isPlaying'].toString()) != null) {
          _youtubeWebPlayerController?.setPlayerState(
            duration: _getDuration(stateMap['duration'].toString())!,
            position: _getDuration(stateMap['position'].toString())!,
            isPlaying: stateMap['isPlaying'] == true,
          );
        }
      }
    });
  }

  /// Convert a String representing milliseconds to a Duration.
  Duration? _getDuration(String text) {
    return Duration(seconds: (double.parse(text)).floor());
  }

  /// Play the video by sending a message to the WebView.
  void _onPlay() {
    _inAppWebViewController?.evaluateJavascript(source: "playerPlay()");
  }

  /// Pause the video by sending a message to the WebView.
  void _onPause() {
    _inAppWebViewController?.evaluateJavascript(source: "playerPause()");
  }

  /// Seek to a specific duration in the video by sending a message to the WebView.
  void _onSeekTo(Duration duration) {
    _inAppWebViewController?.evaluateJavascript(
        source: "playerSeekTo(${duration.inMilliseconds / 1000})");
  }

  /// Set the playback speed of the video by sending a message to the WebView.
  void _onSetPlaybackSpeed(double speed) {
    _inAppWebViewController?.evaluateJavascript(
        source: "playerSetPlaybackSpeed($speed)");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Positioned.fill(
          child: InAppWebView(
            initialData: InAppWebViewInitialData(
              // Load the YouTube player HTML, replacing the video ID with the current video's ID.
              data: _webPlayer.replaceAll("%VIDEO_ID%", widget.videoId),
            ),
            initialSettings: InAppWebViewSettings(
              // Allow fullscreen mode.
              iframeAllowFullscreen: widget.isIframeAllowFullscreen,
              // Allow inline playback.
              allowsInlineMediaPlayback: widget.isAllowsInlineMediaPlayback,
              // Set a transparent background for the WebView.
              transparentBackground: true,
            ),
            onWebViewCreated: (controller) {
              // Assign the WebView controller when the WebView is created.
              _inAppWebViewController = controller;
            },
          ),
        ),
      ],
    );
  }
}

/// HTML template for the YouTube player embedded in a WebView.
/// The %VIDEO_ID% placeholder will be replaced with the actual video ID when rendering.
String _webPlayer = """
  <!DOCTYPE html>
  <html lang="en">
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
          * {
              margin: 0px
          }
  
          body {
              height: 100vh;
              width: 100vw;
          }
      </style>
  
      <script>
          var youtubeController = null;
  
          // HTML TO FLUTTER ADAPTER
  
          function getState() {
              if (!youtubeController) {
                  console.error("youtubeController NOT READY")
                  return null;
              }
  
              return {
                  duration: youtubeController.playerInfo.progressState.duration,
                  position: youtubeController.playerInfo.progressState.current,
                  isPlaying: youtubeController.playerInfo.playerState == YT.PlayerState.PLAYING,
              }
          }
  
          function playerPause() {
              youtubeController.pauseVideo();
          }
          function playerPlay() {
              youtubeController.playVideo()
          }
          function playerSeekTo(second) {
              youtubeController.seekTo(second);
          }
          function playerSetPlaybackSpeed(speed) {
              youtubeController.setPlaybackRate(speed);
          }
  
          function onPlayerReady(e) {
              console.log("onPlayerReady", e);
              youtubeController = e.target;
              youtubeController.hideVideoInfo();
          }
  
          function onPlayerPlaybackQualityChange(e) {
              // NOTHING TO DO
              // console.log("onPlayerPlaybackQualityChange", e)
          }
  
          function onPlayerStateChange(e) {
              switch (e.data) {
                  case YT.PlayerState.ENDED: {
                      //
                      break;
                  }
                  case YT.PlayerState.PLAYING: {
                      //
                      break;
                  }
                  case YT.PlayerState.PAUSED: {
  
                      break;
                  }
                  case YT.PlayerState.BUFFERING: {
  
                      break;
                  }
                  case YT.PlayerState.CUED: {
  
                      break;
                  }
                  default:
                      break;
              }
  
              console.log("onPlayerStateChange", e)
          }
  
  
          function onPlayerError(e) {
              console.log("onPlayerError", e)
          }
      </script>
  </head>
  <body>
      <iframe id="v" width="100%" height="100%"
              src="https://www.youtube.com/embed/%VIDEO_ID%?disablekb=1&enablejsapi=1&controls=0&fs=0&playsinline=1"
              title="YouTube video player" frameborder="0"
              allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
              referrerpolicy="strict-origin-when-cross-origin" donotallowfullscreen="1"
              allowfullscreen="0">
      </iframe>
  <script>
      var tag = document.createElement('script');
      tag.src = "https://www.youtube.com/player_api";
      var firstScriptTag = document.getElementsByTagName('script')[0];
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
  
      var player;
      function onYouTubePlayerAPIReady() {
          player = new YT.Player(document.getElementById("v"), {
              height: window.screen.height.toString(),
              width: window.screen.width.toString(),
              videoId: "%VIDEO_ID%",
              playerVars: { 'autoplay': 1, 'controls': 0, 'showinfo': 0, 'fs': 0, 'playsinline': 1 },
              events: {
                  'onReady': onPlayerReady,
                  'onPlaybackQualityChange': onPlayerPlaybackQualityChange,
                  'onStateChange': onPlayerStateChange,
                  'onError': onPlayerError
              }
          });
      }
  </script>
  """;
