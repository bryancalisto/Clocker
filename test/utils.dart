import 'package:clocker/state.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

Widget buildApp(Widget child, GetIt getIt) {
  return ValueListenableBuilder<ThemeMode>(
    valueListenable: getIt<AppState>().themeNotifier,
    builder: (_, ThemeMode currentMode, __) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.transparent,
        theme: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light().copyWith(
            primary: Colors.black,
            onPrimary: Colors.white,
          ),
          splashFactory: InkRipple.splashFactory,
        ),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.light().copyWith(
            primary: const Color(0xff711c91),
            onPrimary: const Color(0xffea00d9),
            secondary: const Color(0xff133e7c),
            onSecondary: const Color(0xff0abdc6),
          ),
          splashFactory: InkRipple.splashFactory,
        ),
        themeMode: currentMode,
        home: child,
      );
    },
  );
}
