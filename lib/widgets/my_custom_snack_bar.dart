import 'package:flutter/material.dart';

class MycustomSnackbar {
  static void showSnackBar(BuildContext context, String title,{bool isError=false}) {
    final snackBar = SnackBar(
      content: Text(title),
      backgroundColor: isError? Colors.red: Colors.green[500],
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Dismiss',
        disabledTextColor: Colors.white,
        textColor: Colors.yellow,
        onPressed: () {
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
