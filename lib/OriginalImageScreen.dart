import 'dart:io';
import 'package:flutter/material.dart';

class OriginalImageScreen extends StatelessWidget {
  final String filePath;

  const OriginalImageScreen({Key? key, required this.filePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Original Image"),
      ),
      body: Center(
        child: FutureBuilder<File?>(
          future: _getImageFile(filePath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error loading image: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data != null) {
              return Image.file(snapshot.data!);
            } else {
              return const Text('Image not found');
            }
          },
        ),
      ),
    );
  }

  Future<File?> _getImageFile(String path) async {
    try {
      File file = File(path);
      if (await file.exists()) {
        return file;
      } else {
        print("File does not exist: $path");
        return null;
      }
    } catch (e) {
      print("Error loading image: $e");
      return null;
    }
  }
}
