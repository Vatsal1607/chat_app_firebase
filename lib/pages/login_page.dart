import 'package:chat_app_firebase/components/custom_button.dart';
import 'package:chat_app_firebase/components/custom_textfield.dart';
import 'package:chat_app_firebase/pages/register_page.dart';
import 'package:chat_app_firebase/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  LoginPage({this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  // signin user
  void signin() async {
    // get the auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailPassword(
          emailController.text, passController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              controller: emailController,
              hintText: 'Enter your email',
              obscureText: false,
            ),
            SizedBox(
              height: 16.0,
            ),
            CustomTextField(
              controller: passController,
              hintText: 'Enter your password',
              obscureText: true,
            ),
            SizedBox(
              height: 16.0,
            ),
            CustomButton(
              btnName: 'Sign in',
              onPress: signin,
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Not a Member?'),
                SizedBox(
                  width: 4.0,
                ),
                InkWell(
                  onTap: widget.onTap,
                  child: Text(
                    'Register now',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
