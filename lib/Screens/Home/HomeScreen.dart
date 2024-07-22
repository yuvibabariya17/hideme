import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hideme/Constant/color_const.dart';
import 'package:hideme/Constant/string_const.dart';
import 'package:hideme/Models/FileModel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:open_file/open_file.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  // late Box<Map<String, String>> filesBox;
  late Box<FileModel> filesBox;

  late Directory _appDirectory;
  var _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    openBox();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      if (await Permission.manageExternalStorage.request().isGranted) {
        setState(() {
          _permissionGranted = true;
        });
        _getAppDirectory();
      } else {
        print('Permission not granted');
      }
    } else {
      setState(() {
        _permissionGranted = true;
      });
      _getAppDirectory();
    }
    return;
  }

  Future<void> _getAppDirectory() async {
    // Get the external storage directory
    Directory? externalDir = Directory('/storage/emulated/0');
    print('App directory path: ${externalDir.path}');

    // Create the app directory if it doesn't exist
    _appDirectory = Directory('${externalDir.path}/HideMe');
    if (!(await _appDirectory.exists())) {
      await _appDirectory.create();
      print('App directory created at: ${_appDirectory.path}');
    } else {
      print('App directory already exists at: ${_appDirectory.path}');
    }
  }

  @override
  void dispose() {
    if (filesBox.isOpen) {
      filesBox.close();
    }
    Hive.close();
    super.dispose();
  }

  Future<void> requestPermissions() async {
    await [
      Permission.storage,
    ].request();
  }

  Future<void> openBox() async {
    await Hive.initFlutter();
    filesBox = await Hive.openBox<FileModel>(Strings.kFilesBox);
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

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );

    if (result != null) {
      List<File> pickedFiles = result.paths.map((path) => File(path!)).toList();
      await _saveFilesToFolder(pickedFiles);
    }
  }

  Future<void> _saveFilesToFolder(List<File> pickedFiles) async {
    for (File file in pickedFiles) {
      String originalPath = file.path;
      // To add Original Path Show
      // String extension = path.extension(originalPath);
      String fileName;
      int index = 1;
      do {
        // fileName = 'hideme$index$extension.hideme';
        fileName = 'File$index.hideme';
        index++;
      } while (await File('${_appDirectory.path}/$fileName').exists());

      String newPath = path.join(_appDirectory.path, fileName);
      await file.copy(newPath);

      FileModel fileModel = FileModel(
        originalPath: originalPath,
        anonymizedName: fileName,
      );

      await filesBox.put(fileName, fileModel);
    }

    Fluttertoast.showToast(
      msg: "Files uploaded successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _openAppDirectory() async {
    if (await _appDirectory.exists()) {
      OpenFile.open(_appDirectory.path);
    } else {
      Fluttertoast.showToast(
        msg: "HideMe folder does not exist",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (!filesBox.isOpen) {
    //   requestPermissionAndOpenBox();
    //   return const Scaffold(
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }
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
                          _pickFiles();
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
                        // OPEN FILE EXPLORER

                        // onTap: () async {
                        //   // Open the HideMe folder
                        //   if (await _appDirectory.exists()) {
                        //     OpenFile.open(_appDirectory.path);
                        //   } else {
                        //     Fluttertoast.showToast(
                        //       msg: "HideMe folder does not exist",
                        //       toastLength: Toast.LENGTH_SHORT,
                        //       gravity: ToastGravity.BOTTOM,
                        //       backgroundColor: Colors.black,
                        //       textColor: Colors.white,
                        //       fontSize: 16.0,
                        //     );
                        //   }
                        // },

                        //OPEN HIDDENFILES SCREEN

                        onTap: () {
                          _openAppDirectory();

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => HiddenFilesScreen(
                          //       filesBox: filesBox,
                          //     ),
                          //   ),
                          // );
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
