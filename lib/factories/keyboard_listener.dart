import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

KeyboardListener createKeyboardListener(Map<String, void Function()> items, FocusNode focusNode, Widget child) {
  return KeyboardListener(
    autofocus: true,
    focusNode: focusNode,
    onKeyEvent: (e) {
      if (e.runtimeType == KeyDownEvent) {
        items[e.character?.toLowerCase()]?.call();
      }
    },
    child: child,
  );
}
