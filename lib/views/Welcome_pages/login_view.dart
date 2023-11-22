// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../constants/pages_route.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services_auth/auth_exceptions.dart';
import '../../services_auth/firebase_auth_provider.dart';
import '../../utilities/button.dart';
import '../../utilities/show_error.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isSecurePassword = true; //new line(_isSecurePassword)
  late final TextEditingController _email;
  late final TextEditingController _password;
  FirebaseCloudStorage c = FirebaseCloudStorage();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Widget togglePassword() {
    //new widget (togglePassword)
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword;
        });
      },
      icon: _isSecurePassword
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //change to white
      body: Center(
        //new line(center)
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  child: Image.asset('images/AirTours-5.png'), //new image
                ),
                // const Text(
                //   'AirTours',
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //       color: Color.fromRGBO(21, 132, 71, 100),
                //       fontSize: 40,
                //       fontWeight: FontWeight.w900),
                // ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white, //change to white
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    //textAlign: TextAlign.center, //this one remove
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.mail), //new line(prefixIcon)
                        border: InputBorder.none, //new line(border)
                        hintText: 'Email',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 13, 213,
                                    130))), //change color to green
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(
                                    255, 13, 213, 130), //change color to green
                                width: 3))),
                  ),
                ),
                const SizedBox(height: 10), //change size to 10
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white), //change color to white
                  child: TextField(
                    //textAlign: TextAlign.center, //this one remove
                    controller: _password,
                    obscureText: _isSecurePassword, //new line(obscureText)
                    decoration: InputDecoration(
                        border: InputBorder.none, //new line(border)
                        prefixIcon:
                            const Icon(Icons.lock), //new line(prefixIcon)
                        hintText: 'Password',
                        suffixIcon: togglePassword(), //new line(suffixIcon)
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(
                                  255, 13, 213, 130)), //change color to green
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(
                                    255, 13, 213, 130), //change color to green
                                width: 3))),
                  ),
                ),
                const SizedBox(height: 10), //change size to 10
                MyButton(
                    title: 'Login',
                    onPressed: () async {
                      final email = _email.text;
                      final pass = _password.text;
                      try {
                        await FirebaseAuthProvider.authService()
                            .logIn(email: email, password: pass);
                        final user =
                            FirebaseAuthProvider.authService().currentUser;
                        final isUserr = await c.isUser(ownerUserId: user!.id);
                        final isAdminn = await c.isAdmin(email: email);
                        if (isUserr) {
                          if (isAdminn) {
                            if (user.isEmailVerified) {
                              await Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                      createFlightRoute, (route) => false);
                            } else {
                              await Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                      verficationRoute, (route) => false);
                            }
                          } else {
                            if (user.isEmailVerified) {
                              await Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                      bottomRoute, (route) => false);
                            } else {
                              await Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                      verficationRoute, (route) => false);
                            }
                          }
                        } else {
                          await showErrorDialog(context,
                              'User is Not Registered in the database');
                        }
                      } on UserNotFoundAuthException {
                        await showErrorDialog(context, 'User Not Found');
                      } on WrongPasswordAuthException {
                        await showErrorDialog(context, 'Wrong Credentials');
                      } on GenericAuthException {
                        await showErrorDialog(context, 'Authentication Error');
                      }
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Not Registered? ',
                    ),
                    TextButton(
                        onPressed: () async {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              registerRoute, (route) => false);
                        },
                        child: const Text("Register Now"))
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