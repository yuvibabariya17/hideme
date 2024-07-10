import 'dart:io';
import 'package:flutter/material.dart';

class OriginalImageScreen extends StatelessWidget {
  final String filePath;

  const OriginalImageScreen({Key? key, required this.filePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String originalFilePath = filePath.substring(0, filePath.length);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Original Image"),
      ),
      body: Center(
        child: Image.file(File(originalFilePath)),
      ),
    );
  }
}
