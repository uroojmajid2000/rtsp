import 'package:config_app/testingpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: TestingPage(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   Color _backgroundColor = Colors.grey;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     _startPeriodicCheck();
//   }

//   void _startPeriodicCheck() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
//       await _checkConfiguration();
//     });
//   }

//   Future<void> _checkConfiguration() async {
//     final url =
//         'https://s3.me-central-1.amazonaws.com/resources.public.upload.test/cameras/39.39.8.124.ip';

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final responseBody = response.bodyBytes;
//         String jsonString = utf8.decode(responseBody);

//         print('Raw JSON response: $jsonString');

//         if (jsonString.startsWith('\uFEFF')) {
//           jsonString = jsonString.substring(1);
//         }

//         try {
//           final config = jsonDecode(jsonString);

//           if (config['devices'] != null &&
//               config['devices'][0]['rtsp'] != null) {
//             setState(() {
//               _backgroundColor = Colors.green;
//             });
//             _startRTSPStream(config['devices'][0]['rtsp']);
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
//     _saveImageEverySecond();
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
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: _backgroundColor,
//         body: Column(
//           children: [
//             Text("hiiii"),
//             GestureDetector(
//                 child: Text("see live streaming on another screen")),
//           ],
//         ));
//   }
// }
