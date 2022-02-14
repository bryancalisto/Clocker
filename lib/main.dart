import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:clocker/stopwatch_vw.dart';
import 'package:clocker/widgets/window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  await Window.hideWindowControls();

  runApp(const MyApp());

  doWhenWindowReady(() {
    const initialSize = Size(350, 200);
    appWindow
      ..size = initialSize
      ..minSize = initialSize
      ..maxSize = initialSize
      ..alignment = Alignment.bottomRight
      ..show();
  });

  Window.setEffect(
    effect: WindowEffect.acrylic,
    color: const Color.fromARGB(29, 250, 250, 227),
  );
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              color: Colors.transparent,
              theme: ThemeData(
                splashFactory: InkRipple.splashFactory,
              ),
              darkTheme: ThemeData.dark().copyWith(
                splashFactory: InkRipple.splashFactory,
              ),
              themeMode: currentMode,
              home: MoveWindow(child: const StopwatchVw()));
          // home: AppWindow());
        });
  }
}