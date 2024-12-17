# youtube_web_player

A Flutter package for playing YouTube videos in a native WebView.

## Getting Started

To use this package, add it to your `pubspec.yaml`:

```yaml
dependencies:
  youtube_web_player: ^0.0.3
```
## or
```yaml
flutter pub add youtube_web_player
```

## Using the player
```yaml
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
          height: MediaQuery.of(context).size.height * 0.5,
          // https://www.youtube.com/watch?v=LpRZi_cOSOI
          child: YoutubeWebPlayer(videoId: 'LpRZi_cOSOI'),
        ),
      ),
    ),
  );
}
```
