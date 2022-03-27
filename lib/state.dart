import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<AppState>(AppState(themeMode: ThemeMode.dark));
}

class AppState {
  late ValueNotifier<ThemeMode> themeNotifier;

  AppState({required ThemeMode themeMode}) {
    themeNotifier = ValueNotifier(themeMode);
  }
}
