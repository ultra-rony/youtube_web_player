import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:youtube_web_player/youtube_web_player.dart';

/// A widget that displays a YouTube video using an embedded WebView.
class YoutubeWebPlayer extends StatefulWidget {
  const YoutubeWebPlayer({
    super.key,

    /// Unique ID for the YouTube video to be played.
    required this.videoId,

    /// Optional custom controller for the player.
    this.controller,

    /// Allow fullscreen for iframe.
    this.isIframeAllowFullscreen = false,

    /// Allow inline playback.
    this.isAllowsInlineMediaPlayback = true,

    /// Automatically start playback when the player is ready.
    this.isAutoPlay = false,

    /// Height of the video player, specified in pixels. This is optional and can be adjusted based on UI needs.
    this.height,

    /// Sets the background color of the video player. Default is black.
    this.background = Colors.black,

    /// [videoStartTimeSeconds] is required, but defaults to 0 if not provided.
    this.videoStartTimeSeconds = 0,
  });

  /// The player controller, can be null.
  final YoutubeWebPlayerController? controller;

  /// The ID of the YouTube video to play.
  final String videoId;

  /// Indicates if fullscreen is allowed.
  final bool isIframeAllowFullscreen;

  /// Indicates if inline playback is allowed.
  final bool isAllowsInlineMediaPlayback;

  /// Automatically starts the video playback when the player is ready.
  final bool isAutoPlay;

  /// Height of the video player, in pixels. This controls the vertical size of the player.
  final double? height;

  /// The background color of the video player. This property allows customization of the player's appearance.
  final Color background;

  /// The desired start time for the video
  final int videoStartTimeSeconds;

  @override
  State<YoutubeWebPlayer> createState() => _YoutubeWebPlayerState();
}

class _YoutubeWebPlayerState extends State<YoutubeWebPlayer>
    with AutomaticKeepAliveClientMixin {
  /// Controller for the InAppWebView.
  InAppWebViewController? _inAppWebViewController;

  /// Timer to periodically check the state of the video.
  Timer? _getStateInterval;

  /// Controller for video playback state.
  YoutubeWebPlayerController? _youtubeWebPlayerController;

  YoutubeWebPlayerHandler? _youtubeWebPlayerHandler;

  /// Keeps the state alive when switching tabs.
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    /// Use the provided controller or instantiate a new one.
    _youtubeWebPlayerController =
        widget.controller ?? YoutubeWebPlayerController();

    /// Set the video ID for the controller.
    _youtubeWebPlayerController?.setVideoId(widget.videoId);
  }

  @override
  void dispose() {
    /// Clean up resources on widget disposal.
    /// Dispose the player controller.
    _youtubeWebPlayerController?.dispose();

    /// Cancel the state checking timer.
    _getStateInterval?.cancel();
    super.dispose();
  }

  /// Method to load video state periodically.
  loadData() {
    /// Check if the interval for getting the state is currently active.
    if (_getStateInterval?.isActive != null) {
      /// If the interval is active, exit the function to avoid executing further.
      if (_getStateInterval!.isActive) {
        /// Exit early if the interval is active.
        return;
      }
    }

    /// Start a timer to check the state of the video every second.
    _getStateInterval = Timer.periodic(const Duration(seconds: 1), (res) async {
      /// Exit if the widget is not mounted.
      if (!mounted) {
        return;
      }

      /// Evaluate JavaScript to get the current state of the video.
      final response = await _youtubeWebPlayerHandler?.getState();
      if (response != null) {
        /// Create a map to hold state values.
        final stateMap = response.toStringMap();

        /// Update the controller state if values are valid.
        if (double.tryParse(stateMap['position'].toString()) != null &&
            double.tryParse(stateMap['duration'].toString()) != null &&
            bool.tryParse(stateMap['isPlaying'].toString()) != null) {
          _youtubeWebPlayerController?.setPlayerState(
            duration: stateMap['duration'].toString().toDuration()!,
            position: stateMap['position'].toString().toDuration()!,
            isPlaying: bool.parse(stateMap['isPlaying']!),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: widget.background,
      height: widget.height ?? 300,
      child: InAppWebView(
        initialData: InAppWebViewInitialData(
          /// Load the YouTube player HTML, replacing the video ID with the current video's ID.
          data: YoutubeWebPlayerTemplate.webPlayer
              .replaceAll("%VIDEO_ID%", widget.videoId)
              .replaceAll("%AUTO_PLAY%", widget.isAutoPlay ? "1" : "0")
              .replaceAll("%START%", widget.videoStartTimeSeconds.toString()),
        ),
        initialSettings: InAppWebViewSettings(
          /// Allow fullscreen mode.
          iframeAllowFullscreen: widget.isIframeAllowFullscreen,

          /// Allow inline playback.
          allowsInlineMediaPlayback: widget.isAllowsInlineMediaPlayback,

          /// Media playback doesn't require user gesture
          mediaPlaybackRequiresUserGesture: false,

          /// Set a transparent background for the WebView.
          transparentBackground: true,
        ),
        onWebViewCreated: (controller) {
          /// Assign the WebView controller when the WebView is created.
          _inAppWebViewController = controller;
          _youtubeWebPlayerHandler = YoutubeWebPlayerHandler(
            inAppWebViewController: _inAppWebViewController,
            youtubeWebPlayerController: _youtubeWebPlayerController,
          );
        },
        onConsoleMessage: (controller, consoleMessage) {},
        onLoadStop: (controller, url) {
          /// Call loadData to initialize the player and video state.
          loadData();
        },
      ),
    );
  }
}
