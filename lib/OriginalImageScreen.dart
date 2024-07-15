import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hideme/Constant/color_const.dart';
import 'package:sizer/sizer.dart';

class OriginalImageScreen extends StatelessWidget {
  final String filePath;

  const OriginalImageScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: white,
            )),
        title: Text(
          "Original Files",
          style: TextStyle(
            color: white,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: black,
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
