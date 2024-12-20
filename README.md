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
  youtube_web_player: ^0.1.5
```

or run the command

```yaml
flutter pub add youtube_web_player
```

## Using the player

import

```bash
import 'package:youtube_web_player/youtube_web_player.dart';
```

Full screen disable mode

```bash
YoutubeWebPlayer(videoId: 'NsJLhRGPv-M')
```

Full screen mode

```bash
YoutubeWebPlayer(
    videoId: 'NsJLhRGPv-M',
    isIframeAllowFullscreen: true,
    isAllowsInlineMediaPlayback: false,
)
```

Controller

```bash
_controller = YoutubeWebPlayerController.getController("NsJLhRGPv-M");
final movieDuration = _controller?.value.duration;
final position = _controller?.value.duration;

YoutubeWebPlayer(
    videoId: 'NsJLhRGPv-M',
    controller: _controller
),
  
TextButton(
    onPressed: () {
        _controller?.play?.call();
        //_controller?.pause?.call();
    },
    child: Text("Play"),
),
 
 TextButton(
    onPressed: () {
        _controller!.seekTo!(position + Duration(seconds: 5))?.call();
    },
    child: Text(">>>"),
), 

TextButton(
    onPressed: () {
        _controller!.seekTo!(position - Duration(seconds: 5))?.call();
    },
    child: Text("<<<"),
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
        </tr>
    </table>
</div>