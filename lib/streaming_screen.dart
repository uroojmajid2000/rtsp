import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VideoStreamScreen extends StatefulWidget {
  final String rtspUrl;

  VideoStreamScreen({required this.rtspUrl});

  @override
  _VideoStreamScreenState createState() => _VideoStreamScreenState();
}

class _VideoStreamScreenState extends State<VideoStreamScreen> {
  late VlcPlayerController _vlcViewController;

  @override
  void initState() {
    super.initState();
    _vlcViewController = VlcPlayerController.network(
      widget.rtspUrl,
      autoPlay: true,
    );
  }

  @override
  void dispose() {
    _vlcViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Streaming'),
      ),
      body: Center(
        child: VlcPlayer(
          controller: _vlcViewController,
          aspectRatio: 16 / 9,
          placeholder: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
