import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hideme/Constant/color_const.dart';
import 'package:hideme/Screens/AuthPin/PinEntryScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  _PinSetupScreenState createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;

  Future<void> _savePin(String pin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', pin);
  }

  void _onKeyPress(String value) {
    setState(() {
      if (_isConfirming) {
        if (value == 'DEL') {
          if (_confirmPin.isNotEmpty) {
            _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
          }
        } else {
          if (_confirmPin.length < 4) {
            _confirmPin += value;
          }
        }
      } else {
        if (value == 'DEL') {
          if (_pin.isNotEmpty) {
            _pin = _pin.substring(0, _pin.length - 1);
          }
        } else {
          if (_pin.length < 4) {
            _pin += value;
          }
        }
      }
    });
  }

  void _onSubmit() {
    if (_pin.length == 4 && _confirmPin.length == 4) {
      if (_pin == _confirmPin) {
        _savePin(_pin).then((_) {
          Get.off(const PinEntryScreen());

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => const PinEntryScreen()),
          // );
        });
      } else {
        _showErrorDialog('PINs do not match. Please try again.');
      }
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

  Widget _buildPinDots(String pin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: 8.w,
          height: 3.5.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < pin.length ? Colors.black : Colors.grey,
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
        title: Text(_isConfirming
            ? 'Authentication Confirm PIN'
            : 'Authentication Set PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _isConfirming ? 'Confirm your PIN' : 'Enter a 4-digit PIN',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20.0),
            _buildPinDots(_isConfirming ? _confirmPin : _pin),
            const SizedBox(height: 20.0),
            _buildKeypad(),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                if (_isConfirming) {
                  _onSubmit();
                } else if (_pin.length == 4) {
                  setState(() {
                    _isConfirming = true;
                  });
                }
              },
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
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     if (_isConfirming) {
            //       _onSubmit();
            //     } else if (_pin.length == 4) {
            //       setState(() {
            //         _isConfirming = true;
            //       });
            //     }
            //   },
            //   child: Text(_isConfirming ? 'Submit' : 'Next'),
            // ),
          ],
        ),
      ),
    );
  }
}
