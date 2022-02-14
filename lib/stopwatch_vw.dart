import 'dart:async';

import 'package:clocker/main.dart';
import 'package:clocker/styles.dart';
import 'package:clocker/widgets/button.dart';
import 'package:clocker/widgets/switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StopwatchVw extends StatefulWidget {
  const StopwatchVw({Key? key}) : super(key: key);

  @override
  _StopwatchVwState createState() => _StopwatchVwState();
}

class _StopwatchVwState extends State<StopwatchVw> {
  // UI
  bool darkModeOn = false;

  bool isWorking = false;
  bool paused = false;
  bool stopped = false;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  late Timer timer;
  final playIcon = Icons.play_arrow;
  final pauseIcon = Icons.pause;
  late FocusNode _node;

  @override
  void initState() {
    _node = FocusNode();
  }

  String pad(int num) {
    return num.toString().padLeft(2, '0');
  }

  void start() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;

        if (seconds == 60) {
          minutes++;
        }

        if (minutes == 60) {
          hours++;
        }

        minutes %= 60;
        seconds %= 60;
      });
    });

    setState(() {
      isWorking = true;
      paused = false;
      stopped = false;
    });
  }

  void pause() {
    timer.cancel();

    setState(() {
      paused = true;
    });
  }

  void stop() {
    timer.cancel();

    setState(() {
      stopped = true;
      paused = true;
    });
  }

  void restart() {
    setState(() {
      hours = 0;
      minutes = 0;
      seconds = 0;
      isWorking = false;
      paused = false;
      stopped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      autofocus: true,
      focusNode: _node,
      onKeyEvent: (e) {
        if (e.runtimeType == KeyDownEvent) {
          switch (e.character?.toLowerCase()) {
            case ' ':
              paused ? start() : pause();
              break;
            case 's':
              stop();
              break;
            case 'r':
              restart();
              break;
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              bottom: 10,
              right: 10,
              child: DarkModeSwitch(onToggle: (val) {
                if (val) {
                  MyApp.themeNotifier.value = ThemeMode.dark;
                } else {
                  MyApp.themeNotifier.value = ThemeMode.light;
                }
              }),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${pad(hours)}:', style: kTimeNumbersStyle),
                    Text('${pad(minutes)}:', style: kTimeNumbersStyle),
                    Text(pad(seconds), style: kTimeNumbersStyle),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Button(
                      onPressed: () {
                        if (paused || !isWorking) {
                          start();
                        } else {
                          pause();
                        }
                      },
                      icon: !isWorking
                          ? playIcon
                          : paused
                              ? playIcon
                              : pauseIcon,
                    ),
                    if (isWorking || stopped) ...[
                      const SizedBox(
                        width: 5,
                      ),
                      Button(
                          onPressed: () {
                            if (stopped) {
                              restart();
                            } else {
                              stop();
                            }
                          },
                          icon: stopped ? Icons.restart_alt : Icons.stop)
                    ] else
                      Container()
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
