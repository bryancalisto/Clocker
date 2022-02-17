import 'package:clocker/stopwatch_vw.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

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
    case 's':
      logicalKey = LogicalKeyboardKey.keyS;
      break;
    default:
      throw ArgumentError('Key \'$key\' not supported');
  }

  await tester.sendKeyUpEvent(logicalKey); // To unpress keys in the same test

  return await tester.sendKeyDownEvent(logicalKey);
}

Future<void> fastForward(WidgetTester tester, int secs) async {
  return await tester.pump(const Duration(seconds: 4));
}

void main() {
  testWidgets('Clock should start when space bar is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(buildApp(const StopwatchVw()));
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
    await tester.pumpWidget(buildApp(const StopwatchVw()));
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
}
