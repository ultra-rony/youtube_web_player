/// Represents the state of the YouTube Web Player.
class YoutubeWebPlayerState {
  /// Total duration of the video.
  Duration duration = Duration.zero;

  /// Current playback position of the video.
  Duration position = Duration.zero;

  /// Indicates whether the video is currently playing.
  bool isPlaying = false;

  /// Indicates whether the player is ready to play.
  bool isReady = false;

  /// Constructor to create a new YoutubeWebPlayerState with specified duration, position, and playing status.
  YoutubeWebPlayerState(
    this.duration, // The total duration of the video.
    this.position, // The current position of playback.
    this.isPlaying, // Playing status.
  );

  /// Factory constructor to create a YoutubeWebPlayerState from a JSON object.
  YoutubeWebPlayerState.fromJson(Map<String, dynamic> json) {
    // Parse the position and duration only if they are valid numbers.
    if (double.tryParse(json['position'].toString()) != null &&
        double.tryParse(json['duration'].toString()) != null &&
        bool.tryParse(json['isPlaying'].toString()) != null) {
      // Convert position from seconds to milliseconds and create Duration.
      position = Duration(
          milliseconds:
              (double.parse(json['position'].toString()) * 1000).floor());
      // Convert duration from seconds to milliseconds and create Duration.
      duration = Duration(
          milliseconds:
              (double.parse(json['duration'].toString()) * 1000).floor());
      // Parse the isPlaying status from the JSON.
      isPlaying =
          json['isPlaying'] == true; // Using direct access instead of parsing.
    }
  }
}
