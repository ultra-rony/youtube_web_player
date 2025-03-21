import 'package:example/example_controller.dart';
import 'package:flutter/material.dart';
import 'package:youtube_web_player/youtube_web_player.dart';

import 'example_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => Scaffold(
              appBar: AppBar(
                title: const Text('youtube_web_player Demo'),
              ),
              body: Center(
                child: Column(
                  children: [
                    YoutubeWebPlayer(
                      videoId: 'NsJLhRGPv-M',
                      isIframeAllowFullscreen: true,
                      isAllowsInlineMediaPlayback: false,
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExampleList(),
                        ),
                      ),
                      child: Text("Example 1"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExampleController(),
                        ),
                      ),
                      child: Text("Example 2"),
                    ),
                  ],
                ),
              ),
            ),
      },
    );
  }
}
