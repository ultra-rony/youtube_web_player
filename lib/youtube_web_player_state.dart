class YoutubeWebPlayerState {
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;
  bool isReady = false;

  YoutubeWebPlayerState(
    this.duration,
    this.position,
    this.isPlaying,
  );

  YoutubeWebPlayerState.fromJson(Map<String, dynamic> json) {
    if (double.tryParse(json['position'].toString()) != null &&
        double.tryParse(json['duration'].toString()) != null &&
        bool.tryParse(json['duration'].toString()) != null) {
      position = Duration(
          milliseconds:
              (double.parse(json['position'].toString()) * 1000).floor());
      duration = Duration(
          milliseconds:
              (double.parse(json['duration'].toString()) * 1000).floor());
      isPlaying = bool.parse(json['isPlaying']);
    }
  }
}
