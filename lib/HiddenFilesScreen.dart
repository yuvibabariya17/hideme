import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hideme/Constant/color_const.dart';
import 'package:hideme/Constant/string_const.dart';
import 'package:hideme/Models/FileModel.dart';
import 'package:hideme/OriginalImageScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

class HiddenFilesScreen extends StatefulWidget {
  Box<FileModel>? filesBox;

  HiddenFilesScreen({
    super.key,
    required this.filesBox,
  });

  @override
  State<HiddenFilesScreen> createState() => _HiddenFilesScreenState();
}

class _HiddenFilesScreenState extends State<HiddenFilesScreen> {
  List<String> _hiddenFiles = [];

  @override
  void initState() {
    super.initState();
    openBox();
  }

  Future<void> openBox() async {
    if (widget.filesBox != null) {
      widget.filesBox = await Hive.openBox<FileModel>(Strings.kFilesBox);
      if (widget.filesBox!.isOpen) {
        List<FileModel> fileModels = widget.filesBox!.values.toList();
        List<String> uploadedFileNames =
            fileModels.map((model) => model.anonymizedName).toList();
        setState(() {
          _hiddenFiles = uploadedFileNames;
        });
      }
    }
  }

  Future<void> deleteFileFromDatabase(String fileName) async {
    try {
      if (!_hiddenFiles.contains(fileName)) {
        return;
      }
      // Remove from Hive database
      await widget.filesBox!.delete(fileName);

      // Update local list immediately
      setState(() {
        _hiddenFiles.remove(fileName);
      });

      Fluttertoast.showToast(
        msg: "File deleted successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print("File '$fileName' deleted from database.");
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

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
          "Hidden Files",
          style: TextStyle(
            color: white,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: black,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 7.w, right: 7.w, top: 3.h),
        child: _hiddenFiles.isEmpty
            ? const Center(
                child: Text(
                  "You don't have any data",
                  style: TextStyle(fontSize: 20.0),
                ),
              )
            : ListView.builder(
                itemCount: _hiddenFiles.length,
                itemBuilder: (context, index) {
                  String fileName = _hiddenFiles[index];
                  return Dismissible(
                    key: Key(fileName),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: const Text("Confirm"),
                            content: Text(
                              "Delete $fileName?",
                              style: const TextStyle(color: black),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Cancel",
                                    style: TextStyle(color: black)),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text("Delete",
                                    style: TextStyle(color: black)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      deleteFileFromDatabase(fileName);
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
                        child: FadeInLeft(
                          child: Container(
                            height: 6.5.h,
                            width: SizerUtil.width / 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black,
                            ),
                            margin: EdgeInsets.only(
                                left: 7.w, right: 7.w, top: 1.h, bottom: 1.h),
                            child: Center(
                              child: Text(
                                fileName,
                                style: const TextStyle(color: Colors.white),
                              ),
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
