import 'package:config_app/chewie.dart';
import 'package:config_app/streaming_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color _backgroundColor = Colors.grey;
  Timer? _timer;
  String? _rtspUrl;
  TextEditingController _configUrlController = TextEditingController();
  TextEditingController _rtspUrlController = TextEditingController();
  String? configUrl;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _checkConfiguration() async {
    if (configUrl == null || configUrl!.isEmpty) {
      print('Config URL is not provided');
      return;
    }

    try {
      final response = await http.get(Uri.parse(configUrl!));
      if (response.statusCode == 200) {
        final responseBody = response.bodyBytes;
        String jsonString = utf8.decode(responseBody);

        if (jsonString.startsWith('\uFEFF')) {
          jsonString = jsonString.substring(1);
        }

        try {
          final config = jsonDecode(jsonString);

          if (config['devices'] != null &&
              config['devices'][0]['rtsp'] != null) {
            setState(() {
              _backgroundColor = Colors.green;
              _rtspUrl = config['devices'][0]['rtsp'];
              _rtspUrlController.text = _rtspUrl!;
            });
          }
        } catch (jsonError) {
          print('Error parsing JSON: $jsonError');
        }
      } else {
        print(
            'Failed to load configuration. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching configuration: $e');
    }
  }

  void _startRTSPStream(String rtspUrl) {
    // _saveImageEverySecond();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChewiewVideoStreamScreen(rtspUrl: rtspUrl),
      ),
    );
  }

  void _saveImageEverySecond() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      await _captureAndSaveImage();
    });
  }

  Future<void> _captureAndSaveImage() async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);
    final filename = 'ip_${formattedDate}.jpeg';

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';
    File file = File(filePath);
    await file.writeAsBytes([]); // Placeholder for actual image data

    print('Image saved: $filePath');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _configUrlController.dispose();
    _rtspUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text("RTSP Live Streaming"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _configUrlController,
              decoration: InputDecoration(
                labelText: 'Config URL',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                configUrl = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _checkConfiguration();
              },
              child: Text("Fetch Configuration"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _rtspUrlController,
              decoration: InputDecoration(
                labelText: 'RTSP URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_rtspUrlController.text.isNotEmpty) {
                  _startRTSPStream(_rtspUrlController.text);
                } else {
                  print('RTSP URL not available');
                }
              },
              child: Text("Start Live Streaming"),
            ),
          ],
        ),
      ),
    );
  }
}
