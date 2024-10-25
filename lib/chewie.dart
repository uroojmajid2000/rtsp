import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

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
            showOptions: false,
            allowMuting: true,
            
            // allowFullScreen: true,
            aspectRatio: _videoPlayerController.value.aspectRatio,

            // errorBuilder: (context, errorMessage) {
            //   return Center(
            //     child: Text(
            //       errorMessage,
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   );
            // },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Streaming'),
      ),
      body: _chewieController != null &&
              _chewieController!.videoPlayerController.value.isInitialized
          ? Center(
              child: Container(
                alignment: Alignment.center,
                child: Transform.rotate(
                    angle: 270 * 3.1416 / 180,
                    child: Chewie(controller: _chewieController!)),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
