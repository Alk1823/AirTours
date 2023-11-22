import 'package:flutter/material.dart';
import '../../constants/pages_route.dart';
import '../../services_auth/firebase_auth_provider.dart';
import '../../utilities/button.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //change to white
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 200, //change image
                      child: Image.asset(
                        'images/email.png',
                        color: const Color.fromARGB(
                            255, 13, 213, 130), //change color to green
                      ),
                    ),
                    const Text(
                      'Check Your Email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromARGB(
                              255, 13, 213, 130), //change color to green
                          fontSize: 40,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyButton(
                        title: 'After Confirmation, Login here',
                        onPressed: () async {
                          await FirebaseAuthProvider.authService().logOut();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              loginRoute, (route) => false);
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Not Verified Yet? '),
                        TextButton(
                            onPressed: () async {
                              await FirebaseAuthProvider.authService()
                                  .sendEmailVerification();
                            },
                            child: const Text('Send Verfication Again')),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}