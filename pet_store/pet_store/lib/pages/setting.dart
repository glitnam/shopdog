import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_store/pages/change_password.dart';
import 'package:pet_store/pages/login_page.dart';
import 'package:pet_store/r.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    void signOut() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    }

    void changePassword() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Setting'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              _item(
                title: 'Change Password',
                icon: AssetIcons.changePassword,
                handlePage: changePassword,
              ),
              _item(
                title: 'Sign Out',
                icon: AssetIcons.signOut,
                handlePage: signOut,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
      {required String title,
      required String icon,
      required Function handlePage}) {
    return GestureDetector(
      onTap: () {
        handlePage();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              icon,
              height: 30,
              width: 30,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
