import 'package:flutter/material.dart';
import 'package:hideme/Constant/color_const.dart';
import 'package:hideme/OriginalImageScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

class HiddenFilesScreen extends StatefulWidget {
  final List<String> hiddenFiles;

  const HiddenFilesScreen({Key? key, required this.hiddenFiles})
      : super(key: key);

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

  void deleteFileFromDatabase(String filePath) async {
    var box = await Hive.openBox('myBox');
    await box.delete(filePath);
    setState(() {
      _hiddenFiles.remove(filePath); // Remove from local list
    });
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
            String filePath = _hiddenFiles[index];

            String fileNameWithSuffix = filePath.split('/').last;
            int suffixIndex = fileNameWithSuffix.lastIndexOf('.hideme');
            String originalFileName = suffixIndex != -1
                ? fileNameWithSuffix.substring(0, suffixIndex)
                : fileNameWithSuffix;

            return Dismissible(
              key: Key(filePath), // Unique key for each item
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                // Remove the item from the list
                // setState(() {
                //   _hiddenFiles.removeAt(index);
                // });
                // Call your delete logic here
                deleteFileFromDatabase(filePath);
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: GestureDetector(
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
              ),
            );
          },
        ),
      ),
    );
  }


  
}


