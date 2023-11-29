import 'package:AirTours/constants/pages_route.dart';
import 'package:flutter/material.dart';
import '../../services_auth/auth_exceptions.dart';
import '../../services_auth/firebase_auth_provider.dart';
import '../../utilities/show_error.dart';



class LoginForEmailChanges extends StatefulWidget {
  const LoginForEmailChanges({super.key});

  @override
  State<LoginForEmailChanges> createState() => _LoginForEmailChangesState();
}

class _LoginForEmailChangesState extends State<LoginForEmailChanges> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isSecurePassword = true; //new line(_isSecurePassword)
  final formKey = GlobalKey<FormState>();




  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 213, 130),
        title: const Text('Login To Verify It Is You'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  //new line (container and all of it is inside)
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 8, right: 8), //0
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 13, 213,
                            130), //new line(border) and(color) Green color
                      ),
                      boxShadow: const [
                        BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.circular(13),
                      color: Colors.white),
                  child: TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.mail,color: Colors.green,), //new line(prefixIcon)
                      border: InputBorder.none,
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z]+\.(com)$').hasMatch(value)) {
                        return 'Enter correct email';
                      } else {
                        return null;
                      } 
                    },
                  
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  //new line (container and all of it is inside)
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 8, right: 8), //0
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 13, 213,
                            130), //new line(border) and(color) Green color
                      ),
                      boxShadow: const [
                        BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.circular(13),
                      color: Colors.white),
                  child: TextFormField(
                    controller: _password,
                    obscureText: _isSecurePassword, //new line(obscureText)
                    decoration: InputDecoration(
                      border: InputBorder.none, //new line(border)
                      prefixIcon: const Icon(Icons.key,color: Colors.green,), //new line(prefixIcon)
                      hintText: 'Password',
                      suffixIcon: togglePassword(), //new line(suffixIcon)
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a Valid Password';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    bool isSuccessful = false;
                    setState(() {
                      if (formKey.currentState!.validate()) {
                          isSuccessful = true;
                        }
                      });
                    if (isSuccessful) {
                      try {
                  await FirebaseAuthProvider.authService().logIn(email: _email.text, password: _password.text);
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                      updateEmailRoute, 
                      (route) => false
                      );
                  }
                  on UserNotFoundAuthException {
                      await showErrorDialog(context, 'User not found');
                    } on WrongPasswordAuthException {
                      await showErrorDialog(context, 'Wrong credentials');
                    } on GenericAuthException {
                      await showErrorDialog(context, 'Authentication Error');
                    } 
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 1,
                              offset: Offset(0, 0)) //change blurRadius
                        ],
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 13, 213, 130)),
                    child: const Center(
                        child: Text(
                      'Login',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


