import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'controllers.dart';

/// A handler class for controlling a YouTube web player within an InAppWebView.
/// It facilitates communication between the Flutter app and the web player.
class YoutubeWebPlayerHandler {
  /// Constructs a [YoutubeWebPlayerHandler] with provided parameters.
  ///
  /// The [inAppWebViewController] is used to send messages to the web view,
  /// and the [youtubeWebPlayerController] allows for setting method callbacks.
  YoutubeWebPlayerHandler({
    required this.inAppWebViewController,
    required this.youtubeWebPlayerController,
  }) {
    /// Set up the methods that the YouTube web player can call.
    youtubeWebPlayerController?.setMethods(
      /// Method to pause video playback
      pause: _onPause,

      /// Method to start video playback
      play: _onPlay,

      /// Method to seek to a specific duration
      seekTo: _onSeekTo,

      /// Method to set playback speed
      setPlaybackSpeed: _onSetPlaybackSpeed,
    );
  }

  /// Controller for the InAppWebView
  final InAppWebViewController? inAppWebViewController;

  /// Controller for YouTube Web Player
  final YoutubeWebPlayerController? youtubeWebPlayerController;

  /// Retrieves the current state of the video player from the WebView.
  ///
  /// This asynchronous method sends a JavaScript command to the WebView
  /// to execute the 'getState()' function, which is expected to return
  /// a map representing the current state of the video player.
  ///
  /// Returns a [Future] that resolves to a [Map<Object?, Object?>]
  /// containing the state values received from the JavaScript function.
  Future<Map<Object?, Object?>> getState() async {
    /// Ensure the controller is not null before evaluating JavaScript.
    if (inAppWebViewController == null) {
      throw Exception("InAppWebViewController is not initialized");
    }

    /// Await the result of the JavaScript function call in the WebView.
    final result =
        await inAppWebViewController?.evaluateJavascript(source: "getState()");

    /// If result is null, you can either return an empty map or throw an exception
    if (result == null) {
      /// Return an empty map to avoid 'Null' type issue
      return {};
    }

    /// Otherwise, return the result as Map<Object?, Object?>
    return result as Map<Object?, Object?>;
  }

  /// Play the video by sending a message to the WebView.
  ///
  /// This method calls the JavaScript function 'playerPlay()' in the web view,
  /// which is responsible for playing the video.
  void _onPlay() {
    inAppWebViewController?.evaluateJavascript(source: "playerPlay()");
  }

  /// Pause the video by sending a message to the WebView.
  ///
  /// This method calls the JavaScript function 'playerPause()' in the web view,
  /// which is responsible for pausing the video playback.
  void _onPause() {
    inAppWebViewController?.evaluateJavascript(source: "playerPause()");
  }

  /// Seek to a specific duration in the video by sending a message to the WebView.
  ///
  /// The [duration] parameter represents the target duration to seek to.
  /// This method calls the JavaScript function 'playerSeekTo(seconds)',
  /// where seconds is derived from the provided Duration.
  void _onSeekTo(Duration duration) {
    inAppWebViewController?.evaluateJavascript(
        source: "playerSeekTo(${duration.inMilliseconds / 1000})");
  }

  /// Set the playback speed of the video by sending a message to the WebView.
  ///
  /// This method calls the JavaScript function 'playerSetPlaybackSpeed(speed)',
  /// where speed is the desired playback speed (e.g., 1.0 for normal speed).
  void _onSetPlaybackSpeed(double speed) {
    inAppWebViewController?.evaluateJavascript(
        source: "playerSetPlaybackSpeed($speed)");
  }
}
