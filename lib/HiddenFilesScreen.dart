import 'package:flutter/material.dart';
import 'package:hideme/Models/FileModel.dart';
import 'package:hideme/OriginalImageScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

class HiddenFilesScreen extends StatefulWidget {
  final List<String> hiddenFiles;
  //final Box<Map<String, String>> filesBox;
  final Box<FileModel>? filesBox;

  const HiddenFilesScreen({
    super.key,
    required this.hiddenFiles,
    required this.filesBox,
  });

  @override
  State<HiddenFilesScreen> createState() => _HiddenFilesScreenState();
}

class _HiddenFilesScreenState extends State<HiddenFilesScreen> {
  late List<String> _hiddenFiles;

  @override
  void initState() {
    super.initState();
    _hiddenFiles = List.from(widget.hiddenFiles);
  }

  Future<void> deleteFileFromDatabase(String fileName) async {
    try {
      await widget.filesBox!.delete(fileName); // Remove from Hive database
      setState(() {
        _hiddenFiles.remove(fileName); // Remove from local list
      });
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hidden Files"),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 7.w, right: 7.w, top: 3.h),
        child: ListView.builder(
          itemCount: _hiddenFiles.length,
          itemBuilder: (context, index) {
            String fileName = _hiddenFiles[index];
            return Dismissible(
              key: Key(fileName),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                deleteFileFromDatabase(fileName);
                setState(() {});
              },
              background: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.red,
                ),
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: GestureDetector(
                onTap: () {
                  String originalPath =
                      widget.filesBox!.get(fileName)!.originalPath;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OriginalImageScreen(
                        filePath: originalPath,
                      ),
                    ),
                  );
                },
                child: Center(
                  child: Container(
                    height: 6.5.h,
                    width: SizerUtil.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                    ),
                    margin: EdgeInsets.only(
                        left: 7.w, right: 7.w, top: 1.h, bottom: 1.h),
                    // padding: EdgeInsets.only(
                    //     left: 5.w, right: 5.w, top: 2.h, bottom: 2.h),
                    child: Center(
                      child: Text(
                        fileName,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
