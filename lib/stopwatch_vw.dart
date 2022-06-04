import 'dart:async';
import 'dart:io';

import 'package:clocker/state.dart';
import 'package:clocker/styles.dart';
import 'package:clocker/utils/theme_utils.dart';
import 'package:clocker/widgets/button.dart';
import 'package:clocker/widgets/switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class StopwatchVw extends StatefulWidget {
  const StopwatchVw({Key? key}) : super(key: key);

  @override
  _StopwatchVwState createState() => _StopwatchVwState();
}

class _StopwatchVwState extends State<StopwatchVw> {
  bool isWorking = false;
  bool paused = false;
  bool stopped = false;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  Timer? _timer;
  final playIcon = Icons.play_arrow;
  final pauseIcon = Icons.pause;
  late FocusNode _node;

  @override
  void initState() {
    _node = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  String pad(int num) {
    return num.toString().padLeft(2, '0');
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  void start() {
    cancelTimer();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    cancelTimer();

    setState(() {
      paused = true;
    });
  }

  void stop() {
    cancelTimer();

    setState(() {
      stopped = true;
      paused = true;
    });
  }

  void restart() {
    stop();

    setState(() {
      hours = 0;
      minutes = 0;
      seconds = 0;
      isWorking = false;
      paused = false;
      stopped = false;
    });
  }

  void quit() {
    cancelTimer();
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      autofocus: true,
      focusNode: _node,
      onKeyEvent: (e) {
        if (e.runtimeType == KeyDownEvent) {
          switch (e.character?.toLowerCase()) {
            case ' ': // Pause / Continue
              paused || !isWorking ? start() : pause();
              break;
            case 's': // Stop
              stop();
              break;
            case 'r': // Restart
              restart();
              break;
            case 't': // App theme toggle
              setTheme(GetIt.I<AppState>().themeNotifier.value != ThemeMode.dark);
              break;
            case 'q': // Quits the program
              quit();
              break;
          }
        }
      },
      child: Scaffold(
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
