// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:intl/intl.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   Color _backgroundColor = Colors.grey;
//   Timer? _timer;
//   String? _rtspUrl;
//   TextEditingController _configUrlController = TextEditingController();
//   TextEditingController _rtspUrlController = TextEditingController();
//   String? configUrl;

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> _checkConfiguration() async {
//     if (configUrl == null || configUrl!.isEmpty) {
//       print('Config URL is not provided');
//       return;
//     }

//     try {
//       final response = await http.get(Uri.parse(configUrl!));
//       if (response.statusCode == 200) {
//         final responseBody = response.bodyBytes;
//         String jsonString = utf8.decode(responseBody);

//         if (jsonString.startsWith('\uFEFF')) {
//           jsonString = jsonString.substring(1);
//         }

//         try {
//           final config = jsonDecode(jsonString);

//           if (config['devices'] != null &&
//               config['devices'][0]['rtsp'] != null) {
//             setState(() {
//               _backgroundColor = Colors.green;
//               _rtspUrl = config['devices'][0]['rtsp'];
//               _rtspUrlController.text = _rtspUrl!;
//             });
//           }
//         } catch (jsonError) {
//           print('Error parsing JSON: $jsonError');
//         }
//       } else {
//         print(
//             'Failed to load configuration. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching configuration: $e');
//     }
//   }

//   void _startRTSPStream(String rtspUrl) {
//     // _saveImageEverySecond();
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ChewiewVideoStreamScreen(rtspUrl: rtspUrl),
//       ),
//     );
//   }

//   void _saveImageEverySecond() {
//     Timer.periodic(Duration(seconds: 1), (timer) async {
//       await _captureAndSaveImage();
//     });
//   }

//   Future<void> _captureAndSaveImage() async {
//     final now = DateTime.now();
//     final formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);
//     final filename = 'ip_${formattedDate}.jpeg';

//     final directory = await getApplicationDocumentsDirectory();
//     final filePath = '${directory.path}/$filename';
//     File file = File(filePath);
//     await file.writeAsBytes([]);
//     print('Image saved: $filePath');
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _configUrlController.dispose();
//     _rtspUrlController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _backgroundColor,
//       appBar: AppBar(
//         title: Text("RTSP Live Streaming"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _configUrlController,
//               decoration: InputDecoration(
//                 labelText: 'Config URL',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) {
//                 configUrl = value;
//               },
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 await _checkConfiguration();
//               },
//               child: Text("Fetch Configuration"),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _rtspUrlController,
//               decoration: InputDecoration(
//                 labelText: 'RTSP URL',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 if (_rtspUrlController.text.isNotEmpty) {
//                   _startRTSPStream(_rtspUrlController.text);
//                 } else {
//                   print('RTSP URL not available');
//                 }
//               },
//               child: Text("Start Live Streaming"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:config_app/chewie.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color _backgroundColor = Colors.grey;
  Timer? _timer;
  String? _rtspUrl1;
  String? _rtspUrl2;
  TextEditingController _configUrlController = TextEditingController();
  TextEditingController _rtspUrlController1 = TextEditingController();
  TextEditingController _rtspUrlController2 = TextEditingController();
  String? configUrl;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
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
              _rtspUrl1 = config['devices'][0]['rtsp'];
              _rtspUrl2 = config['devices'][0]['rtsp'];
              _rtspUrlController1.text = _rtspUrl1!;
              _rtspUrlController2.text = _rtspUrl2!;
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

  void _startRTSPStream(String rtspUrl1, String rtspUrl2) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultipleVideoStreamScreen(
          rtspUrl1: rtspUrl1,
          rtspUrl2: rtspUrl2,
        ),
      ),
    );
  }

  void _saveImagesPeriodically() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      await _captureAndSaveImageFromStreams();
    });
  }

  Future<void> _captureAndSaveImageFromStreams() async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);

    final directory = await _createDirectory();

    // Save images from stream 1
    final filePath1 = '$directory/stream1_$formattedDate.jpeg';
    await _saveImageFromStream(_rtspUrl1!, filePath1);

    // Save images from stream 2
    final filePath2 = '$directory/stream2_$formattedDate.jpeg';
    await _saveImageFromStream(_rtspUrl2!, filePath2);
  }

  Future<void> _saveImageFromStream(String rtspUrl, String filePath) async {
    // Replace with logic to capture frame from RTSP stream
    File file = File(filePath);
    await file
        .writeAsBytes([]); // Empty byte array, replace with actual image data
    print('Image saved: $filePath');
  }

  Future<String> _createDirectory() async {
    final directory = await getExternalStorageDirectory();
    final dirPath = '${directory?.path}/MyApp/Images';
    final myDir = Directory(dirPath);
    if (!(await myDir.exists())) {
      await myDir.create(recursive: true);
    }
    return dirPath;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _configUrlController.dispose();
    _rtspUrlController1.dispose();
    _rtspUrlController2.dispose();
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
              controller: _rtspUrlController1,
              decoration: InputDecoration(
                labelText: 'RTSP URL 1',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _rtspUrlController2,
              decoration: InputDecoration(
                labelText: 'RTSP URL 2',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_rtspUrlController1.text.isNotEmpty &&
                    _rtspUrlController2.text.isNotEmpty) {
                  _startRTSPStream(
                    _rtspUrlController1.text,
                    _rtspUrlController2.text,
                  );
                } else {
                  print('Both RTSP URLs are required');
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
