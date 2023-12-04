import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart'; //new line

Future<void> showErrorDialog(BuildContext context, String text) async{
  //new method
  return await QuickAlert.show(
      context: context,
      title: 'Error occurred',
      text: text,
      type: QuickAlertType.error);
}