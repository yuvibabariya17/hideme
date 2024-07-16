import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hideme/Constant/color_const.dart';
import 'package:hideme/HiddenFilesScreen.dart';
import 'package:hideme/Models/FileModel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:file_picker/file_picker.dart';

const String kFilesBox = 'files';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

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
    //requestPermissionAndOpenBox();
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

  Future<void> requestPermissionAndOpenBox() async {
    // Request permissions if not already granted
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      Fluttertoast.showToast(
        msg: "Permission denied to access storage",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      // Permission is granted, open the Hive box
      await openBox();
    }
  }

  Future<void> saveFilesToFolder(List<File> pickedFiles) async {
    Directory? directory = await getExternalStorageDirectory();
    String folderName = "HideMeFiles";
    String folderPath = '${directory!.path}/$folderName';
    Directory(folderPath).createSync(recursive: true);

    for (File file in pickedFiles) {
      String originalPath = file.path;
      String fileName = originalPath.split('/').last;
      String filePath = '$folderPath/$fileName';

      await file.copy(filePath);

        print("File saved to: $filePath");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!filesBox.isOpen) {
      requestPermissionAndOpenBox();
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        title: FadeInLeft(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.visibility_off,
                size: 2.8.h,
                color: white,
              ),
              SizedBox(width: 2.w),
              SizedBox(
                child:
                    Container(color: Colors.white, height: 3.5.h, width: 0.5.w),
              ),
              SizedBox(width: 2.w),
              Text(
                "HideMe App",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: FadeInLeft(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black,
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.any,
                            allowMultiple: true,
                          );
                          if (result != null) {
                            List<File> pickedFiles = result.paths
                                .map((path) => File(path!))
                                .toList();
                            int index = filesBox.keys.length + 1;
                            for (File file in pickedFiles) {
                              String originalPath = file.path;
                              String extension = originalPath.split('.').last;
                              String fileName;
                              do {
                                fileName = 'hideme$index.$extension.hideme';
                                // fileName = 'hideme$index.jpg.hideme';
                                index++;
                              } while (filesBox
                                  .containsKey(fileName)); // Ensure unique key
                              FileModel fileModel = FileModel(
                                originalPath: originalPath,
                                anonymizedName: fileName,
                              );
                              filesBox.put(fileName, fileModel);
                              Fluttertoast.showToast(
                                msg: "Files uploaded successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              ); // Store FileModel instance
                            }

                            setState(() {
                              uploadedFiles = filesBox.values
                                  .map((model) => model.anonymizedName)
                                  .toList();
                            });
                            await saveFilesToFolder(pickedFiles);
                          }
                        },
                        child: FadeInLeft(
                          child: Container(
                            height: 7.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: Text(
                                "Browse the Files",
                                style: TextStyle(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        ),
                      ),
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
                        child: FadeInLeft(
                          child: Container(
                            height: 7.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: Text(
                                "View Hidden Files",
                                style: TextStyle(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.visible,
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
      ),
    );
  }
}
