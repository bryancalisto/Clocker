import 'package:clocker/state.dart';
import 'package:clocker/styles.dart';
import 'package:clocker/views/chronometer_vw.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'utils.dart';

Future<bool> press(WidgetTester tester, String key) async {
  LogicalKeyboardKey logicalKey;

  switch (key) {
    case ' ':
      logicalKey = LogicalKeyboardKey.space;
      break;
    case 'r':
      logicalKey = LogicalKeyboardKey.keyR;
      break;
    case 't':
      logicalKey = LogicalKeyboardKey.keyT;
      break;
    case 'q':
      logicalKey = LogicalKeyboardKey.keyQ;
      break;
    default:
      throw ArgumentError('Key \'$key\' not supported');
  }

  await tester.sendKeyUpEvent(logicalKey); // To unpress keys in the same test

  return await tester.sendKeyDownEvent(logicalKey);
}

Future<void> fastForward(WidgetTester tester, int secs) async {
  return await tester.pump(Duration(seconds: secs));
}

Future<void> tap(WidgetTester tester, IconData icon) async {
  return await tester.tap(find.byIcon(icon));
}

late AppState state;
late GetIt getIt;

void main() {
  setUp(() {
    getIt = GetIt.instance;
    state = AppState(themeMode: ThemeMode.dark);
    getIt.registerSingleton<AppState>(state);
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('Clock controls with shorcut keys', () {
    testWidgets('Clock should start when space bar is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp(const ChronometerVw(), getIt));
      // Hours, minutes and seconds should start in 0
      expect(find.text('00:'), findsNWidgets(2));
      expect(find.text('00'), findsOneWidget);
      await press(tester, ' ');
      // Fast forward 4 seconds
      await fastForward(tester, 4);
      expect(find.text('00:'), findsNWidgets(2));
      expect(find.text('04'), findsOneWidget);
    });

    testWidgets('Clock should pause when space bar is pressed when the clock is running', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp(const ChronometerVw(), getIt));
      // Hours, minutes and seconds should start in 0
      expect(find.text('00:'), findsNWidgets(2));
      expect(find.text('00'), findsOneWidget);
      await press(tester, ' ');
      // Fast forward 4 seconds
      await fastForward(tester, 4);
      expect(find.text('00:'), findsNWidgets(2));
      expect(find.text('04'), findsOneWidget);
      // Pause
      await press(tester, ' ');
      await fastForward(tester, 4);
      // Time should have not changed
      expect(find.text('00:'), findsNWidgets(2));
      expect(find.text('04'), findsOneWidget);
    });

    testWidgets('Clock should restart when r is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp(const ChronometerVw(), getIt));
      // Hours, minutes and seconds should start in 0
      expect(find.text('00:'), findsNWidgets(2));
      expect(find.text('00'), findsOneWidget);
      await press(tester, ' ');
      // Fast forward 3723 seconds (01:02:03)
      await fastForward(tester, 3723);
      expect(find.text('01:'), findsOneWidget);
      expect(find.text('02:'), findsOneWidget);
      expect(find.text('03'), findsOneWidget);
      // Restart
      await press(tester, 'r');
      await fastForward(tester, 4);
      // Time should be 0 and should not change until started again
      expect(find.text('00:'), findsNWidgets(2));
      expect(find.text('00'), findsOneWidget);
    });
  });

  group('Clock controls with taps', () {
    testWidgets('Clock should start when play is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp(const ChronometerVw(), getIt));
      // Hours, minutes and seconds should start in 0
      expect(find.text('00:'), findsNWidgets(2));
      expect(find.text('00'), findsOneWidget);
      await tap(tester, kPlayIcon);
      // Fast forward 4 seconds
      await fastForward(tester, 4);
      expect(find.text('00:'), findsNWidgets(2));
      expect(find.text('04'), findsOneWidget);
    });

    testWidgets('Clock should pause when pause is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp(const ChronometerVw(), getIt));
      // Hours, minutes and seconds should start in 0
      expect(find.text('00:'), findsNWidgets(2));
      expect(find.text('00'), findsOneWidget);
      await tap(tester, kPlayIcon);
      // Fast forward 4 seconds
      await fastForward(tester, 4);
      expect(find.text('00:'), findsNWidgets(2));
      expect(find.text('04'), findsOneWidget);
      // Pause
      await tap(tester, kPauseIcon);
      await fastForward(tester, 4);
      // Time should have not changed
      expect(find.text('00:'), findsNWidgets(2));
      expect(find.text('04'), findsOneWidget);
    });

    testWidgets('Clock should restart when restart is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp(const ChronometerVw(), getIt));
      // Hours, minutes and seconds should start in 0
      expect(find.text('00:'), findsNWidgets(2));
      expect(find.text('00'), findsOneWidget);
      await tap(tester, kPlayIcon);
      // Fast forward 3723 seconds (01:02:03)
      await fastForward(tester, 3723);
      expect(find.text('01:'), findsOneWidget);
      expect(find.text('02:'), findsOneWidget);
      expect(find.text('03'), findsOneWidget);
      // Restart
      await tap(tester, kRestartIcon);
      await fastForward(tester, 4);
      // Time should be 0 and should not change until started again
      expect(find.text('00:'), findsNWidgets(2));
      expect(find.text('00'), findsOneWidget);
    });
  });

  group('Theme switching', () {
    testWidgets('Toggles theme when switch key is toggled', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp(const ChronometerVw(), getIt));
      var theSwitch = find.byKey(const Key('themeSwitch'));

      expect(state.themeNotifier.value, ThemeMode.dark);

      await tester.tap(theSwitch);
      await tester.pumpAndSettle();
      expect(state.themeNotifier.value, ThemeMode.light);

      await tester.tap(theSwitch);
      await tester.pumpAndSettle();
      expect(state.themeNotifier.value, ThemeMode.dark);
    });

    testWidgets('Toggles theme when corresponding key is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp(const ChronometerVw(), getIt));

      expect(state.themeNotifier.value, ThemeMode.dark);

      await press(tester, 't');
      await tester.pumpAndSettle();

      expect(state.themeNotifier.value, ThemeMode.light);

      await press(tester, 't');
      await tester.pumpAndSettle();
      expect(state.themeNotifier.value, ThemeMode.dark);
    });
  });
}
