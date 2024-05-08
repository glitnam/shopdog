import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_store/widgets/cta_buton.dart';
import 'package:pet_store/widgets/text_button_login.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    var auth = FirebaseAuth.instance;
    var currentUser = FirebaseAuth.instance.currentUser;

    void changePassword(
        {required String email,
        required String currentPassword,
        required String newPassword}) async {
      var credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await currentUser!.reauthenticateWithCredential(credential).then((value) {
        currentUser.updatePassword(newPassword);
      });
      Navigator.pop(context);
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Change Password'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            LoginBtn1(
              controller: newPasswordController,
              hintText: 'New Password',
              obscureText: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: LoginBtn1(
                controller: confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),
            ),
            CTAButton(
              text: 'Change password',
              onTap: () {
                final currentPassword = currentPasswordController.text.trim();
                final newPassword = newPasswordController.text.trim();
                final confirmPassword = confirmPasswordController.text.trim();
                if (newPassword == confirmPassword) {
                  if (currentUser != null && currentUser.email != null) {
                    changePassword(
                        email: currentUser.email!,
                        currentPassword: currentPassword,
                        newPassword: newPassword);
                  } else {
                    print('User is not logged in or email is not available');
                  }
                } else {
                  print('Passwords do not match');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
