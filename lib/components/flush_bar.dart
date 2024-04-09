
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../services/navigation_service.dart';


showFlushBar(
  String title, {
  bool isError = true,
}) {
  Column(
    children: [

      Flushbar(
        message: title,
        messageText: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        backgroundColor: isError? Colors.red:Colors.green,
        shouldIconPulse: false,
        boxShadows: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 2),
          ),
        ],
        icon: isError
            ? Icon(
                Icons.error,
                color: Colors.white,
                size: 20,
              )
            : Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              ),
        duration: Duration(seconds: 3),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        maxWidth: MediaQuery.of(NavigationService.context!).size.width * 0.7,
      )..show(NavigationService.context!),

    ],
  );
}
