import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

Future<void> showSuccessDialog(BuildContext context, String text) async {
  //new method,change method name
  return await QuickAlert.show(
      context: context,
      title: 'Confirmation',
      text: text,
      type: QuickAlertType.success);
}