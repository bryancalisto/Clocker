import 'package:clocker/state.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void setTheme(isDark) {
  if (isDark) {
    GetIt.I<AppState>().themeNotifier.value = ThemeMode.dark;
  } else {
    GetIt.I<AppState>().themeNotifier.value = ThemeMode.light;
  }
}
