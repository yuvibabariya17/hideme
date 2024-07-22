import 'dart:io';

import 'package:flutter/services.dart';

class MediaStoreUtils {
  static const MethodChannel _channel = MethodChannel('com.example.hideme/media_store');

  static Future<bool> deleteFileFromMediaStore(String filePath) async {
    try {
      final bool result = await _channel.invokeMethod('deleteFile', {'filePath': filePath});
      return result;
    } catch (e) {
      print('Failed to delete file from media store: $e');
      return false;
    }
  }
}