import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hideme/Constant/color_const.dart';
import 'package:hideme/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class PinEntryScreen extends StatefulWidget {
  const PinEntryScreen({super.key});

  @override
  _PinEntryScreenState createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  String _enteredPin = '';

  Future<String?> _getSavedPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('pin');
  }

  void _onKeyPress(String value) {
    setState(() {
      if (value == 'DEL') {
        if (_enteredPin.isNotEmpty) {
          _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        }
      } else {
        if (_enteredPin.length < 4) {
          _enteredPin += value;
        }
      }
    });
  }

  void _onSubmit() async {
    String? savedPin = await _getSavedPin();
    if (_enteredPin == savedPin && _enteredPin.isNotEmpty) {
      Get.offAll(const Homescreen());
    } else {
      _showErrorDialog('Incorrect PIN. Please enter Correct PIN.');
      setState(() {
        _enteredPin = '';
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: 8.w,
          height: 3.5.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < _enteredPin.length ? Colors.black : Colors.grey,
          ),
        );
      }),
    );
  }

  Widget _buildKeypad() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.4,
          crossAxisSpacing: 5,
          mainAxisSpacing: 2),
      itemBuilder: (context, index) {
        if (index == 9) {
          return const SizedBox.shrink();
        } else if (index == 10) {
          return _buildKeypadButton('0');
        } else if (index == 11) {
          return _buildKeypadButton('DEL');
        } else {
          return _buildKeypadButton('${index + 1}');
        }
      },
    );
  }

  Widget _buildKeypadButton(String value) {
    return GestureDetector(
      onTap: () {
        _onKeyPress(value);
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1.0),
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
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
            SizedBox(
              width: 2.w,
            ),
            SizedBox(
                child: Container(color: black, height: 3.5.h, width: 0.5.w)),
            SizedBox(
              width: 2.w,
            ),
            Text(
              "HideMe",
              style: TextStyle(
                  fontSize: 15.sp, fontWeight: FontWeight.bold, color: black),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Enter your PIN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20.0),
            _buildPinDots(),
            const SizedBox(height: 20.0),
            _buildKeypad(),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: _onSubmit,
              child: Container(
                height: 5.7.h,
                width: 40.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100), color: black),
                child: Center(
                    child: Text(
                  "Submit",
                  style: TextStyle(color: white, fontSize: 12.sp),
                )),
              ),
            )
          ],
        ),
      ),
    );
 
  }
}
