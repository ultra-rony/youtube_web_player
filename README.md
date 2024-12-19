<p align="center">
    <img src="https://i.ibb.co/fM0sWz8/icon-512.png" height="100" alt="youtube_web_player" />
</p>
# youtube_web_player

A Flutter package for playing YouTube videos in a native WebView.

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
  title: 'Flutter Demo',
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
  ),
  home: Scaffold(
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          // https://www.youtube.com/watch?v=LpRZi_cOSOI
          child: YoutubeWebPlayer(videoId: 'LpRZi_cOSOI'),
        ),
      ),
    ),
  );
}
```

<div style="display: flex;">
    <img src="https://i.ibb.co/VtXzYp0/image-18-12-24-12-51.png" width="50%" alt=""/>
</div>
