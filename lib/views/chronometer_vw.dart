import 'dart:io';

import 'package:clocker/controllers/Chronometer.dart';
import 'package:clocker/factories/keyboardListener.dart';
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

class ChronometerVwState extends State<ChronometerVw> {
  final _chrono = Chronometer();
  final _playIcon = Icons.play_arrow;
  final _pauseIcon = Icons.pause;
  late FocusNode _node;

  @override
  void initState() {
    super.initState();
    _node = FocusNode();
    _chrono.ticksStream.listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _chrono.cancelTimer();
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
        body: Stack(
          children: [
            const Positioned(
              bottom: 10,
              right: 10,
              child: DarkModeSwitch(onToggle: setTheme, key: Key('themeSwitch')),
            ),
            Column(
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
                      icon: _chrono.state == ChronometerState.running ? _pauseIcon : _playIcon,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Button(
                      onPressed: _restart,
                      icon: Icons.restart_alt,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
