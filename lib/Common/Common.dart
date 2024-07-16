// import 'dart:convert';
// import 'dart:io';

// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class Common {
//   Future<Directory?> getmMyAppDirectory() async {
//     if (await Permission.storage.request().isGranted) {
//       Directory? downloadDirectory = await getExternalStorageDirectory();
//       if (downloadDirectory != null) {
//         final myAppDirectory = Directory('${downloadDirectory.path}/MyApp');
//         if (!await myAppDirectory.exists()) {
//           await myAppDirectory.create(recursive: true);
//         }
//         return myAppDirectory;
//       }
//     }
//     return null;
//   }

//   Future<void> saveImagesToMyApp() async {
//     final directory = await getmMyAppDirectory();
//     if (directory == null) {
//       print('Could not access MyAppDirectory');
//       return;
//     }

// List<String> of base64 encoded images final Box<String>imageBox = Hive.box<String>('images');
// final images = imageBox.values.toList();


// for (int i = 0; i < images.length; i++) {
//   final imagePath = '${directory.path}/image_$i.png';
//   final imageFile = File(imagePath);
//   final imageData = base64Decode(images[i]);
//   await imageFile.writeAsBytes(imageData);



//   }

// }

// }
