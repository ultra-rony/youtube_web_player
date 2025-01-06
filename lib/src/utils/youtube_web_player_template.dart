class YoutubeWebPlayerTemplate {
  /// HTML template for the YouTube player embedded in a WebView.
  /// The %VIDEO_ID% placeholder will be replaced with the actual video ID when rendering.
  static String webPlayer = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            * {
                margin: 0px;
                padding: 0;
            }
            body {
                height: 100vh;
                width: 100vw;
                overflow: hidden;
            }
        </style>
    
        <script>
            var youtubeController = null;
    
            // HTML TO FLUTTER ADAPTER
    
            function getState() {
                if (!youtubeController) {
                    console.error("youtubeController NOT READY")
                    return null;
                }
    
                return {
                    duration: youtubeController.playerInfo.progressState.duration,
                    position: youtubeController.playerInfo.progressState.current,
                    isPlaying: youtubeController.playerInfo.playerState == YT.PlayerState.PLAYING,
                }
            }
    
            function playerPause() {
                youtubeController.pauseVideo();
            }
            function playerPlay() {
                youtubeController.playVideo()
            }
            function playerSeekTo(second) {
                youtubeController.seekTo(second);
            }
            function playerSetPlaybackSpeed(speed) {
                youtubeController.setPlaybackRate(speed);
            }
    
            function onPlayerReady(e) {
                console.log("onPlayerReady", e);
                youtubeController = e.target;
                youtubeController.hideVideoInfo();
            }
    
            function onPlayerPlaybackQualityChange(e) {
                // NOTHING TO DO
                // console.log("onPlayerPlaybackQualityChange", e)
            }
    
            function onPlayerStateChange(e) {
                switch (e.data) {
                    case YT.PlayerState.ENDED: {
                        //
                        break;
                    }
                    case YT.PlayerState.PLAYING: {
                        //
                        break;
                    }
                    case YT.PlayerState.PAUSED: {
    
                        break;
                    }
                    case YT.PlayerState.BUFFERING: {
    
                        break;
                    }
                    case YT.PlayerState.CUED: {
    
                        break;
                    }
                    default:
                        break;
                }
    
                console.log("onPlayerStateChange", e)
            }
    
    
            function onPlayerError(e) {
                console.log("onPlayerError", e)
            }
        </script>
    </head>
    <body>
        <iframe id="v" width="100%" height="100%"
                src="https://www.youtube.com/embed/%VIDEO_ID%?disablekb=1&enablejsapi=1&controls=0&fs=0&playsinline=1"
                title="YouTube video player" frameborder="0"
                allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
                referrerpolicy="strict-origin-when-cross-origin" donotallowfullscreen="1"
                allowfullscreen="0">
        </iframe>
    <script>
        var tag = document.createElement('script');
        tag.src = "https://www.youtube.com/player_api";
        var firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
    
        var player;
        function onYouTubePlayerAPIReady() {
            player = new YT.Player(document.getElementById("v"), {
                height: window.screen.height.toString(),
                width: window.screen.width.toString(),
                videoId: "%VIDEO_ID%",
                playerVars: { 'autoplay': 1, 'controls': 0, 'showinfo': 0, 'fs': 0, 'playsinline': 1 },
                events: {
                    'onReady': onPlayerReady,
                    'onPlaybackQualityChange': onPlayerPlaybackQualityChange,
                    'onStateChange': onPlayerStateChange,
                    'onError': onPlayerError
                }
            });
        }
    </script>
  """;
}
