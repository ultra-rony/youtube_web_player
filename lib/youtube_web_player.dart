import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'constants.dart';
import 'youtube_web_player_controller.dart';
import 'youtube_web_player_state.dart';

/// A widget that displays a YouTube video using an embedded WebView.
class YoutubeWebPlayer extends StatefulWidget {
  const YoutubeWebPlayer({
    super.key,
    required this.videoId, // Unique ID for the YouTube video.
    this.controller, // Optional custom controller for the player.
    this.isIframeAllowFullscreen = false, // Allow fullscreen mode for iframe.
    this.isAllowsInlineMediaPlayback = true, // Allow media playback inline.
  });

  final YoutubeWebPlayerController? controller; // The player controller.
  final String videoId; // The ID of the YouTube video to play.
  final bool isIframeAllowFullscreen; // Indicates if fullscreen is allowed.
  final bool
      isAllowsInlineMediaPlayback; // Indicates if inline playback is allowed.

  @override
  State<YoutubeWebPlayer> createState() => _YoutubeWebPlayerState();
}

class _YoutubeWebPlayerState extends State<YoutubeWebPlayer> {
  InAppWebViewController?
      _inAppWebViewController; // Controller for the InAppWebView.
  Timer? _getStateInterval; // Timer for periodically checking the video state.
  YoutubeWebPlayerController?
      _videoPlayerController; // Controller for video playback.

  @override
  void initState() {
    super.initState();
    // Initialize the video player controller. If none is provided, create a new one.
    _videoPlayerController = widget.controller ??
        YoutubeWebPlayerController.getController(widget.videoId);
    loadData(); // Load the initial data.
  }

  /// Load the video state periodically.
  Future<void> loadData() async {
    // Check the video state every second
    _getStateInterval = Timer.periodic(const Duration(seconds: 1), (res) async {
      if (_videoPlayerController!.isDisposed) {
        return; // Exit if the controller is disposed.
      }
      await Future.delayed(
          Duration(microseconds: 100)); // Small delay to avoid race conditions.
      // Evaluate JavaScript to get the current state of the video.
      final response = await _inAppWebViewController?.evaluateJavascript(
          source: "getState()");
      if (response != null) {
        final entries = <String, dynamic>{};
        // Populate state entries from the response.
        for (final entry in response.entries) {
          entries[entry.key.toString()] = entry.value.toString();
        }
        final state = YoutubeWebPlayerState.fromJson(
            entries); // Convert response to state object.

        // Update the video player's state.
        _videoPlayerController?.value.isReady = true; // Mark as ready.
        _videoPlayerController?.value = state; // Set the new state.
      }
    });
  }

  @override
  void dispose() {
    // Clean up resources on widget disposal.
    if (!_videoPlayerController!.isDisposed) {
      _videoPlayerController?.isDisposed =
          true; // Mark the controller as disposed.
      _getStateInterval?.cancel(); // Cancel the timer.
      _videoPlayerController?.dispose(); // Dispose of the controller.
      _inAppWebViewController?.dispose(); // Dispose of the WebView controller.
    }
    super.dispose();
  }

  /// Play the video by evaluating JavaScript in the WebView.
  void onPlay() {
    _inAppWebViewController?.evaluateJavascript(source: "playerPlay()");
  }

  /// Pause the video by evaluating JavaScript in the WebView.
  void onPause() {
    _inAppWebViewController?.evaluateJavascript(source: "playerPause()");
  }

  /// Seek to a specific duration in the video.
  void onSeekTo(Duration duration) {
    _inAppWebViewController?.evaluateJavascript(
        source: "playerSeekTo(${duration.inMilliseconds / 1000})");
  }

  /// Set the playback speed of the video.
  void onSetPlaybackSpeed(double speed) {
    _inAppWebViewController?.evaluateJavascript(
        source: "playerSetPlaybackSpeed($speed)");
  }

  /// Create the InAppWebView for the player with initial data and settings.
  Future<Widget> _player() async {
    return InAppWebView(
      initialData: InAppWebViewInitialData(
        // Load the YouTube player HTML, replacing the video ID.
        data: Constants.webPlayer.replaceAll("%VIDEO_ID%", widget.videoId),
      ),
      initialSettings: InAppWebViewSettings(
        iframeAllowFullscreen: widget.isIframeAllowFullscreen,
        allowsInlineMediaPlayback: widget.isAllowsInlineMediaPlayback,
        transparentBackground:
            true, // Set a transparent background for the WebView.
      ),
      onWebViewCreated: (controller) {
        _inAppWebViewController =
            controller; // Assign the controller when created.
      },
      onConsoleMessage: (controller, consoleMessage) {
        // Handle console messages for debugging if needed.
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_videoPlayerController == null) {
      return const SizedBox(); // Return an empty box if the controller is not available.
    }

    // Bind actions to the controller methods.
    _videoPlayerController!.play = onPlay;
    _videoPlayerController!.pause = onPause;
    _videoPlayerController!.seekTo = onSeekTo;
    _videoPlayerController!.setPlaybackSpeed = onSetPlaybackSpeed;

    return FutureBuilder<Widget>(
      key: ValueKey(Constants.playerKey.hashCode),
      future: _player(), // Load the player asynchronously.
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while waiting.
        }
        return Stack(
          children: [
            Positioned.fill(child: snapshot.data!), // Render the WebView.
          ],
        );
      },
    );
  }
}
