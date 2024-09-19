import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<File> _imageFiles = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final dirPath = directory.path;
    final images = Directory(dirPath).listSync().where((item) {
      return item.path.endsWith('.jpeg'); // Only JPEG images
    }).map((item) => File(item.path)).toList();

    setState(() {
      _imageFiles = images;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery"),
      ),
      body: _imageFiles.isEmpty
          ? Center(child: Text("No images found"))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _imageFiles.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 images per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return Image.file(
                  _imageFiles[index],
                  fit: BoxFit.cover,
                );
              },
            ),
    );
  }
}