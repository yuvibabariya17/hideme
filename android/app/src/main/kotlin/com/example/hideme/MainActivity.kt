package com.example.hideme

import android.os.Bundle
import android.media.MediaScannerConnection
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
  private val CHANNEL = "com.example.hideme/media_scanner"

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "scanFile") {
        val path = call.argument<String>("path")
        scanFile(path)
        result.success(null)
      } else {
        result.notImplemented()
      }
    }
  }

  private fun scanFile(path: String?) {
    path?.let {
      MediaScannerConnection.scanFile(this, arrayOf(it), null, null)
    }
  }
}
