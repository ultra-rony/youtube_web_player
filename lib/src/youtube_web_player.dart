import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../youtube_web_player.dart';

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
    // Automatically start playback when the player is ready.
    this.isAutoPlay = false,
  });

  // The player controller, can be null.
  final YoutubeWebPlayerController? controller;

  // The ID of the YouTube video to play.
  final String videoId;

  // Indicates if fullscreen is allowed.
  final bool isIframeAllowFullscreen;

  // Indicates if inline playback is allowed.
  final bool isAllowsInlineMediaPlayback;

  // Automatically starts the video playback when the player is ready.
  final bool isAutoPlay;

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

  // Indicates whether this is the first time the video is being played.
  bool _isFirstPlay = true;

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
      // Check if this is the first play, the widget is mounted, and autoplay is enabled.
      if (_isFirstPlay && mounted && widget.isAutoPlay) {
        // Set to false after the first play to prevent re-triggering.
        _isFirstPlay = false;
        // Call the play method to start playback.
        _youtubeWebPlayerController?.play.call();
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
              data: YoutubeWebPlayerTemplate.webPlayer
                  .replaceAll("%VIDEO_ID%", widget.videoId),
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
