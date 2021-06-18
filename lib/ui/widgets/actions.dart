import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowAction {
  void showToast(message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void showAlertDialog(String title, String content,
      BuildContext context, Widget widgetA, Widget widgetB) {
    var alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      actions: <Widget>[widgetA, widgetB],
    );

    showDialog(
      context: context,
      builder: (_) => alertDialog,
      barrierDismissible: false,
    );
  }

  static void showDetails(
      String title, String content, BuildContext context, Widget widgetA) {
    var alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      actions: <Widget>[widgetA],
    );

    showDialog(
      context: context,
      builder: (_) => alertDialog,
      barrierDismissible: false,
    );
  }
}
