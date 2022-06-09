import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({required this.onPressed, required this.icon, Key? key}) : super(key: key);

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(side: BorderSide(width: 1, color: Theme.of(context).colorScheme.onPrimary)),
        padding: const EdgeInsets.all(20),
        elevation: 6,
      ),
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
