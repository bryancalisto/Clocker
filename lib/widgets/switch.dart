import 'package:clocker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class DarkModeSwitch extends StatelessWidget {
  final Function(bool) onToggle;

  const DarkModeSwitch({Key? key, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: MyApp.themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return Column(
            children: [
              const Text('Cyber', style: TextStyle(fontSize: 10)),
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
                activeColor: const Color.fromARGB(183, 202, 44, 202),
                padding: 3.0,
                showOnOff: true,
                onToggle: onToggle,
              ),
            ],
          );
        });
  }
}
