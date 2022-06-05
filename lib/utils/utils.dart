import 'dart:io';

String pad(int num) {
  return num.toString().padLeft(2, '0');
}

String getOS() {
  return Platform.operatingSystem;
}
