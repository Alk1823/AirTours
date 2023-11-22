import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  MyButton({required this.title, required this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        borderRadius:
            BorderRadius.circular(20), //change borderRadius circular to 20
        elevation: 10,
        color: const Color.fromARGB(255, 13, 213, 130), //change color to green
        child: MaterialButton(
            onPressed: onPressed,
            height: 45,
            minWidth: 200,
            child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}