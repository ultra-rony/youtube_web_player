import 'package:flutter/material.dart';
import 'package:youtube_web_player/youtube_web_player.dart';

class ExampleController extends StatefulWidget {
  const ExampleController({super.key});

  @override
  State<StatefulWidget> createState() => _ExampleControllerState();
}

class _ExampleControllerState extends State<ExampleController> {
  YoutubeWebPlayerController? _controller;

  @override
  void initState() {
    _controller = YoutubeWebPlayerController();
    _controller?.addListener(_positionListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.removeListener(_positionListener);
    super.dispose();
  }

  _positionListener() {
    print("position: ${_controller!.position}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('youtube_web_player Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          SizedBox(
            height: 300,
            child: YoutubeWebPlayer(
              controller: _controller,
              videoId: "NsJLhRGPv-M",
            ),
          ),
          TextButton(
              onPressed: () => _controller?.play.call(),
              child: Icon(Icons.play_circle, size: 50)),
          TextButton(
              onPressed: () => _controller?.pause.call(),
              child: Icon(Icons.pause_circle, size: 50)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    _controller!
                        .seekTo(_controller!.position - Duration(seconds: 5));
                  },
                  child: Icon(Icons.skip_previous, size: 50)),
              TextButton(
                  onPressed: () {
                    _controller!
                        .seekTo(_controller!.position + Duration(seconds: 5));
                  },
                  child: Icon(Icons.skip_next, size: 50)),
            ],
          ),
          TextButton(
              onPressed: () {
                _controller?.setPlaybackSpeed(1);
              },
              child: Text("SetPlaybackSpeed 1")),
          TextButton(
              onPressed: () {
                _controller?.setPlaybackSpeed(0.5);
              },
              child: Text("SetPlaybackSpeed 0.5")),
        ],
      ),
    );
  }
}
