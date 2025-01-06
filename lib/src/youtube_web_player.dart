import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../youtube_web_player.dart';

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

  /// Indicates whether this is the first time the video is being played.
  bool _isFirstPlay = true;

  YoutubeWebPlayerHandler? _youtubeWebPlayerHandler;

  /// Keeps the state alive when switching tabs.
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    /// Call loadData to initialize the player and video state.
    loadData();
  }

  @override
  void dispose() {
    /// Clean up resources on widget disposal.
    /// Dispose the player controller.
    _youtubeWebPlayerController?.dispose();

    /// Dispose the WebView controller.
    // _inAppWebViewController?.dispose();
    /// Cancel the state checking timer.
    _getStateInterval?.cancel();
    super.dispose();
  }

  /// Method to load video state periodically.
  loadData() {
    /// Use the provided controller or instantiate a new one.
    _youtubeWebPlayerController =
        widget.controller ?? YoutubeWebPlayerController();

    /// Set the video ID for the controller.
    _youtubeWebPlayerController?.setVideoId(widget.videoId);

    /// Check if the interval for getting the state is currently active.
    if (_getStateInterval?.isActive != null) {
      /// If the interval is active, exit the function to avoid executing further.
      if (_getStateInterval!.isActive) {
        return;

        /// Exit early if the interval is active.
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
            isPlaying: bool.parse(stateMap['isPlaying']!) == true,
          );
        }
      }

      /// Check if this is the first play, the widget is mounted, and autoplay is enabled.
      if (_isFirstPlay && mounted && widget.isAutoPlay) {
        /// Set to false after the first play to prevent re-triggering.
        _isFirstPlay = false;

        /// Call the play method to start playback.
        _youtubeWebPlayerController?.play.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: widget.background,
      height: widget.height ?? MediaQuery.of(context).size.height / 3,
      child: InAppWebView(
        initialData: InAppWebViewInitialData(
          /// Load the YouTube player HTML, replacing the video ID with the current video's ID.
          data: YoutubeWebPlayerTemplate.webPlayer
              .replaceAll("%VIDEO_ID%", widget.videoId),
        ),
        initialSettings: InAppWebViewSettings(
          /// Allow fullscreen mode.
          iframeAllowFullscreen: widget.isIframeAllowFullscreen,

          /// Allow inline playback.
          allowsInlineMediaPlayback: widget.isAllowsInlineMediaPlayback,

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
      ),
    );
  }
}
