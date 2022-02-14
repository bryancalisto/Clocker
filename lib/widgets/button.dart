import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({required this.onPressed, required this.icon, Key? key}) : super(key: key);

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
