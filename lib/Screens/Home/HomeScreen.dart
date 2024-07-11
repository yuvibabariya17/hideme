import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hideme/HiddenFilesScreen.dart';
import 'package:hideme/Models/FileModel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:file_picker/file_picker.dart';

const String kFilesBox = 'files';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  // late Box<Map<String, String>> filesBox;
  late Box<FileModel> filesBox;
  List<String> uploadedFiles = [];

  @override
  void initState() {
    super.initState();
    openBox();
  }

  @override
  void dispose() {
    if (filesBox.isOpen) {
      filesBox.close();
    }
    Hive.close();
    super.dispose();
  }

  Future<void> openBox() async {
    await Hive.initFlutter();
    filesBox = await Hive.openBox<FileModel>(kFilesBox);
    // filesBox = await Hive.openBox<Map<String, String>>(kFilesBox);
    if (filesBox.isOpen) {
      // Assuming 'filesBox' is a Box<FileModel>
      List<FileModel> fileModels = filesBox.values.toList();
      List<String> uploadedFileNames =
          fileModels.map((model) => model.anonymizedName).toList();
      setState(() {
        uploadedFiles = uploadedFileNames;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.visibility_off,
              size: 3.h,
            ),
            SizedBox(width: 2.w),
            SizedBox(
              child:
                  Container(color: Colors.black, height: 3.5.h, width: 0.5.w),
            ),
            SizedBox(width: 2.w),
            Text(
              "HideMe",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.any,
                          allowMultiple: true,
                        );
                        if (result != null) {
                          List<File> pickedFiles =
                              result.paths.map((path) => File(path!)).toList();
                          int index = filesBox.keys.length;
                          for (File file in pickedFiles) {
                            String originalPath = file.path;
                            String fileName =
                                'hideme${index + 1}.jpg'; // Anonymized name
                            FileModel fileModel = FileModel(
                              originalPath: originalPath,
                              anonymizedName: fileName,
                            );
                            filesBox.put(fileName,
                                fileModel); // Store FileModel instance
                            index++;
                          }
                          setState(() {
                            uploadedFiles = filesBox.values
                                .map((model) => model.anonymizedName)
                                .toList();
                          });
                        }
                      },
                      child: const Text("Browse the Files"),
                    ),

                    // ElevatedButton(
                    //   onPressed: () async {
                    //     FilePickerResult? result =
                    //         await FilePicker.platform.pickFiles(
                    //       type: FileType.any,
                    //       allowMultiple: true,
                    //     );
                    //     if (result != null) {
                    //       List<File> pickedFiles =
                    //           result.paths.map((path) => File(path!)).toList();
                    //       int index = filesBox.keys.length;
                    //       for (File file in pickedFiles) {
                    //         String originalPath = file.path;
                    //         String fileName =
                    //             'hideme${index + 1}.jpg'; // Anonymized name
                    //         filesBox.put(fileName, {
                    //           'originalPath': originalPath,
                    //           'anonymizedName': fileName
                    //         });
                    //         index++;
                    //       }
                    //       setState(() {
                    //         uploadedFiles = filesBox.values
                    //             .map((entry) => entry['anonymizedName']!)
                    //             .toList();
                    //       });
                    //     }
                    //   },
                    //   child: const Text("Browse the Files"),
                    // ),
                    SizedBox(height: 2.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HiddenFilesScreen(
                              hiddenFiles: uploadedFiles,
                              filesBox: filesBox,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 7.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: GestureDetector(
                          child: const Center(
                            child: Text(
                              "View Hidden Files",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
