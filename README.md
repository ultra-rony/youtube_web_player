<p align="center">
    <img src="https://i.ibb.co/rdQfwSg/icon-512.png" height="100" alt="youtube_web_player" />
</p>

<p align="center">
    <a href="https://pub.dev/packages/youtube_web_player"><img src="https://img.shields.io/badge/pub-v1.0.8-blue" alt="Pub"></a>
    <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
    <a href="https://pub.dev/packages/youtube_web_player/score"><img src="https://img.shields.io/badge/points-160/160-green" alt="Points"></a>
    <a href="https://www.donationalerts.com/r/ultra_rony"><img src="https://img.shields.io/badge/support-donate-yellow" alt="Donate"></a>
    <a href="https://pub.dev/packages/flutter_inappwebview"><img src="https://img.shields.io/badge/flutter_inappwebview-v6.1.5-blue" alt="Inappwebview"></a>
</p>

---

# youtube_web_player
<p>
    A Flutter package for seamless integration of YouTube videos in a native WebView, providing a smooth playback experience. Ideal for multimedia applications.<br>
   <span style="font-size: 0.9em"> Show some ❤️ and <a href="https://github.com/ultra-rony/youtube_web_player">star the repo</a> to support the project! </span>
</p>

## Getting Started

To use this package, add it to your `pubspec.yaml`:

```yaml
dependencies:
  youtube_web_player: ^1.0.8
```

or run the command

```bash
flutter pub add youtube_web_player
```

## Using the player

import

```dart
import 'package:youtube_web_player/youtube_web_player.dart';
```

Full screen disable mode

```dart
YoutubeWebPlayer(videoId: 'NsJLhRGPv-M')
```

Full screen mode

```dart
YoutubeWebPlayer(
    videoId: 'NsJLhRGPv-M',
    isIframeAllowFullscreen: true,
    isAllowsInlineMediaPlayback: false,
);
```

Controller

```dart
YoutubeWebPlayerController? _controller = YoutubeWebPlayerController();

YoutubeWebPlayer(
    controller: _controller,
    videoId: 'NsJLhRGPv-M',
    isIframeAllowFullscreen: true,
    isAllowsInlineMediaPlayback: false,
);
```

Add a listener to track changes in video playback position

```dart
_controller?.addListener(() {
    print("position: ${_controller!.position}");
  };
);
```

Button to seek forward 5 seconds in the video

```dart
_controller!.seekTo(_controller!.position + Duration(seconds: 5));
```

Button to set playback speed to half (0.5x)

```dart
_controller?.setPlaybackSpeed(0.5)
```

```dart
// Declare a controller for interacting with the YouTube video player
YoutubeWebPlayerController? _controller;

@override
void initState() {
  // Initialize the controller when the widget is created
  _controller = YoutubeWebPlayerController();
  // Add a listener to track changes in video playback position
  _controller?.addListener(_positionListener);
  // Call the superclass method to ensure proper initialization
  super.initState();
}

@override
void dispose() {
  // Remove the listener when the widget is disposed to avoid memory leaks
  _controller?.removeListener(_positionListener);
  // Call the superclass method to ensure proper disposal
  super.dispose();
}

// Listener method that prints the current video playback position to the console
_positionListener() {
  print("position: ${_controller!.position}");
}

// Build method to create the widget's UI
@override
Widget build(BuildContext context) {
  return Scaffold(
    // Create a Scaffold to provide a basic material design layout
    appBar: AppBar(
      // Set the title of the app
      title: const Text('youtube_web_player Demo'),
    ),
    body: ListView(
      // Create a ListView for scrolling through multiple widgets
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        SizedBox(
          height: 300,
          // Use YoutubeWebPlayer to display the video
          child: YoutubeWebPlayer(
            controller: _controller,
            videoId: "NsJLhRGPv-M",  // Specify the video ID to play
          ),
        ),
        // Play button to start video playback
        TextButton(
            onPressed: () => _controller?.play.call(),
            child: Icon(Icons.play_circle, size: 50)),
        // Pause button to stop video playback
        TextButton(
            onPressed: () => _controller?.pause.call(),
            child: Icon(Icons.pause_circle, size: 50)),
        Row(
          // Align buttons to the center of the row
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Button to seek back 5 seconds in the video
            TextButton(
                onPressed: () {
                  _controller!
                      .seekTo(_controller!.position - Duration(seconds: 5));
                },
                child: Icon(Icons.skip_previous, size: 50)),
            // Button to seek forward 5 seconds in the video
            TextButton(
                onPressed: () {
                  _controller!
                      .seekTo(_controller!.position + Duration(seconds: 5));
                },
                child: Icon(Icons.skip_next, size: 50)),
          ],
        ),
        // Button to set playback speed to normal (1x)
        TextButton(
            onPressed: () {
              _controller?.setPlaybackSpeed(1);
            },
            child: Text("SetPlaybackSpeed 1")),
        // Button to set playback speed to half (0.5x)
        TextButton(
            onPressed: () {
              _controller?.setPlaybackSpeed(0.5);
            },
            child: Text("SetPlaybackSpeed 0.5")),
      ],
    ),
  );
}
```

## Examples

<div style="text-align: center">
    <table>
        <tr>
            <td style="text-align: center">
                <img src="https://i.ibb.co/gTT9Zs9/image-03-01-25-05-36.png" width="300" alt=""/>
            </td>
            <td style="text-align: center">
                <img src="https://i.ibb.co/PTYSNrf/image-03-01-25-05-38.png" width="300" alt=""/>
            </td>
        </tr>
        <tr>
            <td style="text-align: center">
                <img src="https://i.ibb.co/HNgM4D1/image-19-12-24-11-58-1.png" width="300" alt=""/>
            </td>            
            <td style="text-align: center">
                <img src="https://i.ibb.co/rHBFtnJ/image-19-12-24-11-58-2.png" width="300" alt=""/>
            </td>
        </tr>
    </table>
</div>