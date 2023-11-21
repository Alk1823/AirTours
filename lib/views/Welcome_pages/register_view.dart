import 'package:flutter/material.dart';
import '../../constants/pages_route.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services_auth/auth_exceptions.dart';
import '../../services_auth/firebase_auth_provider.dart';
import '../../utilities/button.dart';
import '../../utilities/show_error.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final FirebaseCloudStorage c = FirebaseCloudStorage();
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _password2;


  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _password2 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _password2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                child: Image.asset('img/tours3.png'),
              ),
              const Text(
                'AirTours',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Color.fromRGBO(137, 147, 158, 1)),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      hintText: 'Enter Email',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 3))),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter Password',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.deepPurple, width: 3)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _password2,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 3))),
                ),
              ),
              const SizedBox(height: 30),
              MyButton(
                  title: 'Register',
                  onPressed: () async {
                    final email = _email.text;
                    final pass = _password.text;
                    final pass2 = _password2.text;
                    if (pass != pass2) {
                      showErrorDialog(context, "Password doesn't match!");
                    } else {
                      try {
                        await FirebaseAuthProvider.authService()
                            .createUser(email: email, password: pass);
                        
                        final String userId =
                            FirebaseAuthProvider.authService().currentUser!.id;
                        final String currentEmail =
                            FirebaseAuthProvider.authService().currentUser!.email;
                        c.createNewUser(
                            ownerUserId: userId,
                            email: currentEmail,
                            phoneNum: '',
                            balance: 0.0);
                        FirebaseAuthProvider.authService().sendEmailVerification();
                        await Navigator.of(context).pushNamed(verficationRoute);
                      } on WeakPasswordAuthException {
                        await showErrorDialog(context, 'Weak password');
                      } on EmailAlreadyInUseAuthException {
                        await showErrorDialog(context, 'Email already in use');
                      } on InvalidEmailAuthException {
                        await showErrorDialog(
                            context, 'This is an invalid email');
                      } on GenericAuthException {
                        await showErrorDialog(context, 'Failed to register');
                      }
                    }
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already registered?'),
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute, (route) => false);
                      },
                      child: const Text('Login here'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
