import 'package:clocker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class DarkModeSwitch extends StatelessWidget {
  final Function(bool) onToggle;

  const DarkModeSwitch({Key? key, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;

    return ValueListenableBuilder(
        valueListenable: MyApp.themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return Column(
            children: [
              Text('Cyber', style: TextStyle(fontSize: 10, color: primaryColor, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 2,
              ),
              FlutterSwitch(
                width: 45.0,
                height: 20.0,
                valueFontSize: 10.0,
                toggleSize: 17.0,
                value: currentMode == ThemeMode.dark,
                borderRadius: 20.0,
                activeColor: primaryColor,
                activeTextColor: onPrimaryColor,
                inactiveColor: primaryColor,
                inactiveTextColor: onPrimaryColor,
                toggleColor: onPrimaryColor,
                padding: 3.0,
                showOnOff: true,
                onToggle: onToggle,
              ),
            ],
          );
        });
  }
}
