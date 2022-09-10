import 'dart:io';

import 'package:clocker/controllers/chronometer.dart';
import 'package:clocker/factories/keyboard_listener.dart';
import 'package:clocker/state.dart';
import 'package:clocker/styles.dart';
import 'package:clocker/utils/theme.dart';
import 'package:clocker/widgets/button.dart';
import 'package:clocker/widgets/switch.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:clocker/utils/utils.dart';

class ChronometerVw extends StatefulWidget {
  const ChronometerVw({Key? key}) : super(key: key);

  @override
  ChronometerVwState createState() => ChronometerVwState();
}

class ChronometerVwState extends State<ChronometerVw> with WidgetsBindingObserver {
  final _chrono = Chronometer();
  late FocusNode _node;

  @override
  void initState() {
    super.initState();
    _node = FocusNode();
    _chrono.ticksStream.listen((event) {
      setState(() {});
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) {
    print('Changed');

    switch (state) {
      case AppLifecycleState.inactive:
        print("Inactive");
        break;
      case AppLifecycleState.paused:
        print("Paused");
        break;
      case AppLifecycleState.resumed:
        print("Resumed");
        break;
      case AppLifecycleState.detached:
        print("Suspending");
        break;
    }

    throw Error();
  }

  @override
  void dispose() {
    _chrono.cancelTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _run() {
    _chrono.run();
    setState(() {});
  }

  void _pause() {
    _chrono.pause();
    setState(() {});
  }

  void _restart() {
    _chrono.restart();
    setState(() {});
  }

  void _quit() {
    _chrono.cancelTimer();
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return createKeyboardListener(
      {
        ' ': () => _chrono.state == ChronometerState.running ? _pause() : _run(),
        'q': _quit,
        'r': _restart,
        't': () => setTheme(GetIt.I<AppState>().themeNotifier.value != ThemeMode.dark),
      },
      _node,
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${pad(_chrono.hours)}:', style: kTimeNumbersStyle),
                Text('${pad(_chrono.minutes)}:', style: kTimeNumbersStyle),
                Text(pad(_chrono.seconds), style: kTimeNumbersStyle),
              ],
            ),
            const DarkModeSwitch(onToggle: setTheme, key: Key('themeSwitch')),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Button(
                  onPressed: () {
                    if (_chrono.state == ChronometerState.running) {
                      _pause();
                    } else {
                      _run();
                    }
                  },
                  icon: _chrono.state == ChronometerState.running ? kPauseIcon : kPlayIcon,
                ),
                if (_chrono.state != ChronometerState.off) ...[
                  const SizedBox(
                    width: 5,
                  ),
                  Button(
                    onPressed: _restart,
                    icon: kRestartIcon,
                  ),
                ] else
                  Container(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
