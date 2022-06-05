import 'package:clocker/state.dart';
import 'package:clocker/utils/platform.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:clocker/views/app_vw.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I;
  setupState();

  runCustomPlatformApp(() => runApp(App(getIt: GetIt.I)));
}
