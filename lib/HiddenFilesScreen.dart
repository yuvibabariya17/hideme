import 'package:flutter/material.dart';
import 'package:hideme/Constant/color_const.dart';
import 'package:hideme/OriginalImageScreen.dart';
import 'package:sizer/sizer.dart';

class HiddenFilesScreen extends StatelessWidget {
  final List<String> hiddenFiles;

  const HiddenFilesScreen({Key? key, required this.hiddenFiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hidden Files"),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 7.w, right: 7.w, top: 3.h),
        child: ListView.builder(
          itemCount: hiddenFiles.length,
          itemBuilder: (context, index) {
            String filePath = hiddenFiles[index];

            String fileNameWithSuffix = filePath.split('/').last;
            int suffixIndex = fileNameWithSuffix.lastIndexOf('.hideme');
            String originalFileName = suffixIndex != -1
                ? fileNameWithSuffix.substring(0, suffixIndex)
                : fileNameWithSuffix;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OriginalImageScreen(filePath: filePath),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                margin: EdgeInsets.only(top: 1.h, bottom: 1.h),
                padding: EdgeInsets.only(
                    left: 5.w, right: 5.w, top: 1.5.h, bottom: 1.5.h),
                child: Text(
                  originalFileName,
                  style: const TextStyle(color: white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void deleteFileFromDatabase(String filePath) {
    // Implement your logic to delete the file from the database
    // Example:
    // database.deleteFile(filePath);
  }
}
