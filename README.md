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
  youtube_web_player: ^0.1.0
```
## or
```yaml
flutter pub add youtube_web_player
```

## Using the player

```bash
@override
Widget build(BuildContext context) {
  return MaterialApp(
  title: 'Youtube web player Demo',
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
  ),
  home: Scaffold(
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: YoutubeWebPlayer(videoId: 'LpRZi_cOSOI'),
        ),
      ),
    ),
  );
}
```
## Examples

<div style="text-align: center">
    <table>
        <tr>
            <td style="text-align: center">
                <a href="https://bloclibrary.dev/tutorials/flutter-counter">
                    <img src="https://i.ibb.co/VtXzYp0/image-18-12-24-12-51.png" width="200"/>
                </a>
            </td>            
            <td style="text-align: center">
                <a href="https://bloclibrary.dev/tutorials/flutter-infinite-list">
                    <img src="https://i.ibb.co/VtXzYp0/image-18-12-24-12-51.png" width="200"/>
                </a>
            </td>
            <td style="text-align: center">
                <a href="https://bloclibrary.dev/tutorials/flutter-login">
                    <img src="https://i.ibb.co/VtXzYp0/image-18-12-24-12-51.png" width="200" />
                </a>
            </td>
        </tr>
        <tr>
            <td style="text-align: center">
                <a href="https://bloclibrary.dev/tutorials/github-search">
                    <img src="https://i.ibb.co/VtXzYp0/image-18-12-24-12-51.png" width="200"/>
                </a>
            </td>
            <td style="text-align: center">
                <a href="https://bloclibrary.dev/tutorials/flutter-weather">
                    <img src="https://i.ibb.co/VtXzYp0/image-18-12-24-12-51.png" width="200"/>
                </a>
            </td>
            <td style="text-align: center">
                <a href="https://bloclibrary.dev/tutorials/flutter-todos">
                    <img src="https://i.ibb.co/VtXzYp0/image-18-12-24-12-51.png" width="200"/>
                </a>
            </td>
        </tr>
    </table>
</div>
