import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:math' as math;

class ChewiewVideoStreamScreen extends StatefulWidget {
  final String rtspUrl;

  ChewiewVideoStreamScreen({required this.rtspUrl});

  @override
  _ChewiewVideoStreamScreenState createState() =>
      _ChewiewVideoStreamScreenState();
}

class _ChewiewVideoStreamScreenState extends State<ChewiewVideoStreamScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.rtspUrl)
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            autoPlay: true,
            looping: false,
            showOptions: true,
            showControls: false,
            allowMuting: false,
          
            aspectRatio: _videoPlayerController.value.aspectRatio,
          );
        });
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _videoPlayerController.setVolume(_isMuted ? 0 : 1); // Mute or unmute
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Streaming'),
      ),
      body: _chewieController != null &&
              _chewieController!.videoPlayerController.value.isInitialized
          ? Stack(
              // alignment: Alignment.center,
              children: [
                // Video rotated by 270 degrees (landscape view)
                Transform.rotate(
                  angle: 270 * math.pi / 180,
                  child: AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: Chewie(controller: _chewieController!),
                  ),
                ),
                // Mute button overlay
                Positioned(
                  bottom: 0,
                  left: 50,
                  child: IconButton(
                    icon: Icon(
                      _isMuted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: _toggleMute,
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
