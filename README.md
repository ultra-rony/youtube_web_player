<p align="center">
    <img src="https://i.ibb.co/rdQfwSg/icon-512.png" height="100" alt="youtube_web_player" />
</p>

<p align="center">
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

---

# youtube_web_player

A Flutter package for seamless integration of YouTube videos in a native WebView, providing a smooth playback experience. Ideal for multimedia applications.

## Getting Started

To use this package, add it to your `pubspec.yaml`:

```yaml
dependencies:
  youtube_web_player: ^0.1.7
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
// Initialize the controller for the YouTube video with the specified ID
YoutubeWebPlayerController? _controller = YoutubeWebPlayerController.getController("NsJLhRGPv-M");

// Get the duration of the video
Duration movieDuration = _controller?.value.duration;

// Get the current position of the video (playback time)
Duration position = _controller?.value.duration;

// Create a YoutubeWebPlayer widget to play the video with the specified ID
YoutubeWebPlayer(
    videoId: 'NsJLhRGPv-M',  // YouTube video ID
    controller: _controller   // Pass the controller for playback control
),

// Button to play the video
TextButton(
    onPressed: () {
        _controller?.play?.call(); // Start playing the video if the controller is available
        //_controller?.pause?.call(); // Commented out line to pause
    },
    child: Text("Play"), // Button text
),

// Button to rewind the video 5 seconds
TextButton(
    onPressed: () {
        // Seek the video forward by 5 seconds from the current position
        _controller!.seekTo!(position + Duration(seconds: 5))?.call();
    },
    child: Text(">>>"), // Button text
), 

// Button to fast-forward the video 5 seconds
TextButton(
    onPressed: () {
        // Seek the video backward by 5 seconds from the current position
        _controller!.seekTo!(position - Duration(seconds: 5))?.call();
    },
    child: Text("<<<"), // Button text
), 
```

## Examples

<div style="text-align: center">
    <table>
        <tr>
            <td style="text-align: center">
                <img src="https://i.ibb.co/HNgM4D1/image-19-12-24-11-58-1.png" width="200"/>
            </td>            
            <td style="text-align: center">
                <img src="https://i.ibb.co/rHBFtnJ/image-19-12-24-11-58-2.png" width="200"/>
            </td>
            <td style="text-align: center">
                <img src="https://i.ibb.co/R4Qt9PN/image-19-12-24-11-58.png" width="200" />
            </td>
            <td style="text-align: center">
                <img src="https://i.ibb.co/jfGds0R/image-20-12-24-07-13.png" width="200" />
            </td>
        </tr>
    </table>
</div>