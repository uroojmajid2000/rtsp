import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart'; // for formatting date

Future<String> _createDirectory() async {
  final directory = await getExternalStorageDirectory();
  final dirPath = '${directory?.path}/MyApp/Images';
  final myDir = Directory(dirPath);
  if (!(await myDir.exists())) {
    await myDir.create(recursive: true);
  }
  return dirPath;
}