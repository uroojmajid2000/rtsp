

















// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
// import 'dart:math' as math;

// class ChewiewVideoStreamScreen extends StatefulWidget {
//   final String rtspUrl;

//   ChewiewVideoStreamScreen({required this.rtspUrl});

//   @override
//   _ChewiewVideoStreamScreenState createState() =>
//       _ChewiewVideoStreamScreenState();
// }

// class _ChewiewVideoStreamScreenState extends State<ChewiewVideoStreamScreen> {
//   late VideoPlayerController _videoPlayerController;
//   ChewieController? _chewieController;
//   bool _isMuted = false;

//   @override
//   void initState() {
//     super.initState();
//     _videoPlayerController = VideoPlayerController.network(widget.rtspUrl)
//       ..initialize().then((_) {
//         setState(() {
//           _chewieController = ChewieController(
//             videoPlayerController: _videoPlayerController,
//             autoPlay: true,
//             looping: false,
//             showOptions: true,
//             showControls: false,
//             allowMuting: false,
          
//             aspectRatio: _videoPlayerController.value.aspectRatio,
//           );
//         });
//       });
//   }

//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }

//   void _toggleMute() {
//     setState(() {
//       _isMuted = !_isMuted;
//       _videoPlayerController.setVolume(_isMuted ? 0 : 1); // Mute or unmute
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Live Streaming'),
//       ),
//       body: _chewieController != null &&
//               _chewieController!.videoPlayerController.value.isInitialized
//           ? Stack(
//               // alignment: Alignment.center,
//               children: [
//                 // Video rotated by 270 degrees (landscape view)
//                 Transform.rotate(
//                   angle: 270 * math.pi / 180,
//                   child: AspectRatio(
//                     aspectRatio: _videoPlayerController.value.aspectRatio,
//                     child: Chewie(controller: _chewieController!),
//                   ),
//                 ),
//                 // Mute button overlay
//                 Positioned(
//                   bottom: 0,
//                   left: 50,
//                   child: IconButton(
//                     icon: Icon(
//                       _isMuted ? Icons.volume_off : Icons.volume_up,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                     onPressed: _toggleMute,
//                   ),
//                 ),
//               ],
//             )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }























import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:math' as math;

class MultipleVideoStreamScreen extends StatefulWidget {
  final String rtspUrl1;
  final String rtspUrl2;

  MultipleVideoStreamScreen({
    required this.rtspUrl1,
    required this.rtspUrl2,
  });

  @override
  _MultipleVideoStreamScreenState createState() =>
      _MultipleVideoStreamScreenState();
}

class _MultipleVideoStreamScreenState extends State<MultipleVideoStreamScreen> {
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController1;
  ChewieController? _chewieController2;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _videoPlayerController1 = VideoPlayerController.network(widget.rtspUrl1)
      ..initialize().then((_) {
        setState(() {
          _chewieController1 = ChewieController(
            videoPlayerController: _videoPlayerController1,
            autoPlay: true,
            looping: false,
            aspectRatio: 16 / 9,
            // videoPlayerController1.value.aspectRatio,

            showOptions: true,
            showControls: false,
            allowMuting: false,
          );
        });
      });

    _videoPlayerController2 = VideoPlayerController.network(widget.rtspUrl2)
      ..initialize().then((_) {
        setState(() {
          _chewieController2 = ChewieController(
            videoPlayerController: _videoPlayerController2,
            autoPlay: true,
            looping: false,
            aspectRatio: 16 / 9,
            //  _videoPlayerController2.value.aspectRatio,

            showOptions: true,
            showControls: false,
            allowMuting: false,
          );
        });
      });
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController1?.dispose();
    _chewieController2?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiple Live Streaming'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _chewieController1 != null &&
                    _chewieController1!
                        .videoPlayerController.value.isInitialized
                ?
                // Chewie(controller: _chewieController1!)

                Transform.rotate(
                    angle: 270 * math.pi / 180,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Chewie(controller: _chewieController1!),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          Expanded(
            child: _chewieController2 != null &&
                    _chewieController2!
                        .videoPlayerController.value.isInitialized
                ?

                //  Chewie(controller: _chewieController2!)

                Transform.rotate(
                    angle: 270 * math.pi / 180,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Chewie(controller: _chewieController2!),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
