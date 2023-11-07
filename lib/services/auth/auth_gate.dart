import 'package:chat_app_firebase/pages/home_page.dart';
import 'package:chat_app_firebase/services/auth/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return HomePage();
          }
          // user is not logged in
          else {
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}
