import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_store/pages/dashboard.dart';
import 'package:pet_store/pages/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // return LoginPage();
            if (snapshot.hasData) {
              return DashBoardPage();
            } else {
              return const LoginPage();
            }
          }),
    );
  }
}
