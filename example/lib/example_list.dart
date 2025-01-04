import 'package:flutter/material.dart';
import 'package:youtube_web_player/youtube_web_player.dart';

class ExampleList extends StatelessWidget {
  const ExampleList({super.key});

  final String _lorem =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('youtube_web_player Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          _child(context),
          const SizedBox(height: 10),
          _child(context),
          const SizedBox(height: 10),
          _child(context),
        ],
      ),
    );
  }

  Widget _child(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: screen.height * 0.20,
          child: YoutubeWebPlayer(
            videoId: 'NsJLhRGPv-M',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                _lorem,
                maxLines: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                _lorem,
                maxLines: 4,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
