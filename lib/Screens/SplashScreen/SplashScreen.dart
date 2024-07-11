import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hideme/Constant/color_const.dart';
import 'package:hideme/Screens/AuthPin/PinEntryScreen.dart';
import 'package:hideme/Screens/AuthPin/PinSetupScreen.dart';
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
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.visibility_off,
            size: 3.h,
          ),
          SizedBox(
            width: 2.w,
          ),
          SizedBox(child: Container(color: black, height: 3.5.h, width: 0.5.w)),
          SizedBox(
            width: 2.w,
          ),
          Text(
            "HideMe",
            style: TextStyle(
                fontSize: 15.sp, fontWeight: FontWeight.bold, color: black),
          ),
        ],
      )),
    );
  }
}
