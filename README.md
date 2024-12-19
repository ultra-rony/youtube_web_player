<p align="center">
    <img src="https://i.ibb.co/rdQfwSg/icon-512.png" height="100" alt="youtube_web_player" />
</p>

<p align="center">
<a href="http://fluttersamples.com"><img src="https://img.shields.io/badge/flutter-samples-teal.svg?longCache=true" alt="Flutter Samples"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

---

# youtube_web_player

A Flutter package for seamless integration of YouTube videos in a native WebView, providing a smooth playback experience. Ideal for multimedia applications.

## Getting Started

To use this package, add it to your `pubspec.yaml`:

```yaml
dependencies:
  youtube_web_player: ^0.1.1
```
## or
```yaml
flutter pub add youtube_web_player
```

## Using the player

import

```bash
import 'package:youtube_web_player/youtube_web_player.dart';
```

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
## Examples

<div style="text-align: center">
    <table>
        <tr>
            <td style="text-align: center">
                <a href="https://bloclibrary.dev/tutorials/flutter-counter">
                    <img src="https://i.ibb.co/HNgM4D1/image-19-12-24-11-58-1.png" width="200"/>
                </a>
            </td>            
            <td style="text-align: center">
                <a href="https://bloclibrary.dev/tutorials/flutter-infinite-list">
                    <img src="https://i.ibb.co/rHBFtnJ/image-19-12-24-11-58-2.png" width="200"/>
                </a>
            </td>
            <td style="text-align: center">
                <a href="https://bloclibrary.dev/tutorials/flutter-login">
                    <img src="https://i.ibb.co/R4Qt9PN/image-19-12-24-11-58.png" width="200" />
                </a>
            </td>
        </tr>
    </table>
</div>