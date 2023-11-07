import 'package:chat_app_firebase/components/custom_button.dart';
import 'package:chat_app_firebase/components/custom_textfield.dart';
import 'package:chat_app_firebase/pages/login_page.dart';
import 'package:chat_app_firebase/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  RegisterPage({this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  // sign up user
  signUp() async {
    if (passController.text != confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password do not match'),
        ),
      );
      return;
    }
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signupWithEmailPaswword(
        emailController.text,
        passController.text,
      );
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
        title: Text('Register page'),
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
            CustomTextField(
              controller: confirmPassController,
              hintText: 'Enter Confirm password',
              obscureText: true,
            ),
            SizedBox(
              height: 16.0,
            ),
            CustomButton(
              btnName: 'Sign up',
              onPress: signUp,
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Already a Member?'),
                SizedBox(
                  width: 4.0,
                ),
                InkWell(
                  onTap: widget.onTap,
                  child: Text(
                    'Login now',
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
