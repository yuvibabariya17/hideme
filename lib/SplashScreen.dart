import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hideme/Constant/color_const.dart';
import 'package:hideme/PinEntryScreen.dart';
import 'package:hideme/PinSetupScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _checkPinSet();
  }

  Future<void> _checkPinSet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pin = prefs.getString('pin');
    bool isPinSet = pin != null && pin.isNotEmpty;

    await Future.delayed(const Duration(seconds: 3));

    if (isPinSet) {
      Get.off(const PinEntryScreen());

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => PinEntryScreen()),
      // );
    } else {
      Get.off(const PinSetupScreen());
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => PinSetupScreen()),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: green,
      body: Center(
          child: Text(
        "SplashScreen",
        style: TextStyle(
            fontSize: 20.sp, fontWeight: FontWeight.bold, color: white),
      )),
    );
  }
}
