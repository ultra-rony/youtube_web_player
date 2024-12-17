import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'constants.dart';
import 'youtube_web_player_controller.dart';
import 'youtube_web_player_state.dart';

class YoutubeWebPlayer extends StatefulWidget {
  const YoutubeWebPlayer({
    super.key,
    required this.videoId,
    this.controller,
    this.iframeAllowFullscreen = false,
    this.allowsInlineMediaPlayback = true,
  });

  final YoutubeWebPlayerController? controller;
  final String videoId;
  final bool iframeAllowFullscreen;
  final bool allowsInlineMediaPlayback;

  @override
  State<YoutubeWebPlayer> createState() => _YoutubeWebPlayerState();
}

class _YoutubeWebPlayerState extends State<YoutubeWebPlayer> {
  InAppWebViewController? _inAppWebViewController;
  Timer? _getStateInterval;
  YoutubeWebPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = widget.controller ??
        YoutubeWebPlayerController.getController(widget.videoId);
    loadData();
  }

  Future<void> loadData() async {
    _getStateInterval = Timer.periodic(const Duration(seconds: 1), (res) async {
      if (_videoPlayerController!.isDisposed) {
        return;
      }
      await Future.delayed(Duration(microseconds: 100));
      final response = await _inAppWebViewController?.evaluateJavascript(
          source: "getState()");
      if (response != null) {
        final entries = <String, dynamic>{};
        for (final entry in response.entries) {
          entries[entry.key.toString()] = entry.value.toString();
        }
        final state = YoutubeWebPlayerState.fromJson(entries);
        _videoPlayerController?.value.isReady = true;
        _videoPlayerController?.value = state;
      }
    });
  }

  @override
  void dispose() {
    if (!_videoPlayerController!.isDisposed) {
      _videoPlayerController?.isDisposed = true;
      _getStateInterval?.cancel();
      _videoPlayerController?.dispose();
      _inAppWebViewController?.dispose();
    }
    super.dispose();
  }

  void onPlay() {
    _inAppWebViewController?.evaluateJavascript(source: "playerPlay()");
  }

  void onPause() {
    _inAppWebViewController?.evaluateJavascript(source: "playerPause()");
  }

  void onSeekTo(Duration duration) {
    _inAppWebViewController?.evaluateJavascript(
        source: "playerSeekTo(${duration.inMilliseconds / 1000})");
  }

  void onSetPlaybackSpeed(double speed) {
    _inAppWebViewController?.evaluateJavascript(
        source: "playerSetPlaybackSpeed($speed)");
  }

  Future<Widget> _player() async {
    return InAppWebView(
      initialData: InAppWebViewInitialData(
        data: Constants.webPlayer.replaceAll("%VIDEO_ID%", widget.videoId),
      ),
      initialSettings: InAppWebViewSettings(
        iframeAllowFullscreen: widget.iframeAllowFullscreen,
        allowsInlineMediaPlayback: widget.allowsInlineMediaPlayback,
        transparentBackground: true,
      ),
      onWebViewCreated: (controller) {
        _inAppWebViewController = controller;
      },
      onConsoleMessage: (controller, consoleMessage) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_videoPlayerController == null) {
      return const SizedBox();
    }
    _videoPlayerController!.play = onPlay;
    _videoPlayerController!.pause = onPause;
    _videoPlayerController!.seekTo = onSeekTo;
    _videoPlayerController!.setPlaybackSpeed = onSetPlaybackSpeed;
    return FutureBuilder<Widget>(
      key: ValueKey(Constants.playerKey.hashCode),
      future: _player(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return Stack(
          children: [
            Positioned.fill(child: snapshot.data!),
          ],
        );
      },
    );
  }
}
