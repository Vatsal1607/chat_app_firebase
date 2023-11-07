import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String btnName;
  final VoidCallback onPress;
  CustomButton({required this.btnName, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPress,
        child: Text(btnName),
      ),
    );
  }
}
