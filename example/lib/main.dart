import 'package:flutter/material.dart';
import 'package:youtube_web_player/youtube_web_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
}
