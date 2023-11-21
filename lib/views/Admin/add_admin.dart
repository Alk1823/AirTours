import 'package:flutter/material.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../utilities/show_error.dart';
import '../../utilities/show_feedback.dart';

class AddAdmin extends StatefulWidget {
  const AddAdmin({super.key});

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  late final TextEditingController _email;
  late final TextEditingController _phoneNum;
  final FirebaseCloudStorage c = FirebaseCloudStorage();

  @override
  void initState() {
    _email = TextEditingController();
    _phoneNum = TextEditingController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _phoneNum,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                   final converted = await c.convertUserToAdmin(email: _email.text,phoneNum: _phoneNum.text);
                   if (converted) {
                      await showFeedback(context, 'Admin Added');
                   } else {
                      await showErrorDialog(context, 'User Not Found');
                   }
              },
              child: const Text('Add Admin'),
            ),
          ],
        ),
      ),
    );
  }
}

