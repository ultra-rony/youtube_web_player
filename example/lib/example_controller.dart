import 'package:flutter/material.dart';
import 'package:youtube_web_player/youtube_web_player.dart';
import 'package:youtube_web_player/youtube_web_player_controller.dart';

class ExampleController extends StatefulWidget {
  const ExampleController({super.key});

  @override
  State<StatefulWidget> createState() => _ExampleControllerState();

}

class _ExampleControllerState extends State<ExampleController> {

  YoutubeWebPlayerController? _controller;

  @override
  void initState() {
    _controller = YoutubeWebPlayerController.getController("NsJLhRGPv-M");
    super.initState();
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
          TextButton(onPressed: () => _controller?.play?.call(), child: Text("play")),
          TextButton(onPressed: () => _controller?.pause?.call(), child: Text("pause")),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: () {
                // _controller?.value.duration; getDuration movie
                _controller!.seekTo!(_controller!.value.position - Duration(seconds: 5))?.call();
              }, child: Text("<<<")),
              TextButton(onPressed: () {
                _controller!.seekTo!(_controller!.value.position + Duration(seconds: 5))?.call();
              }, child: Text(">>>>")),
            ],
          ),
        ],
      ),
    );
  }
}
