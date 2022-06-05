import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:clocker/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

Future<void> runCustomPlatformApp(void Function() runApp) async {
  final os = getOS();

  switch (os) {
    case 'linux':
    case 'macos':
    case 'windows':
      await Window.initialize();
      await Window.hideWindowControls();

      runApp();

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
      break;
    default:
      runApp();
  }
}
