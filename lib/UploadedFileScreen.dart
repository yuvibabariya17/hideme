import 'package:flutter/material.dart';
import 'package:hideme/OriginalImageScreen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

const String kFilesBox = 'files'; // Hive box name
const String kFileSuffix = '.hideme'; // Suffix added to uploaded file names

class UploadedFilesScreen extends StatefulWidget {
  const UploadedFilesScreen({Key? key}) : super(key: key);

  @override
  _UploadedFilesScreenState createState() => _UploadedFilesScreenState();
}

class _UploadedFilesScreenState extends State<UploadedFilesScreen> {
  late Box<String> filesBox; // Hive box to store file paths
  List<String> uploadedFiles = []; // List to hold uploaded file paths

  @override
  void initState() {
    super.initState();
    openBox();
  }

  Future<void> openBox() async {
    await Hive.initFlutter();
    filesBox = await Hive.openBox<String>(kFilesBox);
    setState(() {
      uploadedFiles = filesBox.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Uploaded Files'),
      ),
      body: uploadedFiles.isEmpty
          ? Center(
              child: Text('No files uploaded yet'),
            )
          : ListView.builder(
              itemCount: uploadedFiles.length,
              itemBuilder: (context, index) {
                String filePath = uploadedFiles[index];
                if (filePath.endsWith(kFileSuffix)) {
                  String fileName = filePath.substring(
                      0, filePath.length - kFileSuffix.length);
                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => FileDetailsScreen(filePath),
                      //   ),
                      // );
                    },
                    child: Container(
                      height: 7.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink(); // Skip non-.hideme files
                }
              },
            ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
