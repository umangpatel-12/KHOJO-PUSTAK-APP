import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Otptextfield extends StatefulWidget {
  const Otptextfield({super.key});

  @override
  State<Otptextfield> createState() => _OtptextfieldState();
}

class _OtptextfieldState extends State<Otptextfield> {
  int _secound = 60;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _canResend = false;
    _secound = 60;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer){
      if(_secound == 0){
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      }
      else {
        setState(() {
          _secound--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resendOTP() {
    print("OTP Resend");
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _canResend ?
          GestureDetector(
            onTap: _resendOTP,
            child: Text(
              "Resend OTP",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 12,color: Colors.green[200],fontWeight: FontWeight.w500),
            ),
          )
            : Text(
                "Resend OTP in $_secound s",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 12,color: Colors.green[200],fontWeight: FontWeight.w500),
              ),
      ],
    );
  }
}
