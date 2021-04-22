import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:beacons/beacons.dart' show Beacons, Beacon;

void main() {
  test('Uses correct fontFamily', () {
    expect(Beacons.family, 'Beacons');
  });

  testWidgets('Uses default font size of 24', (WidgetTester tester) async {
    await tester.pumpWidget(Container(child: Beacon('btc')));
    final Icon widget = tester.widget(find.byType(Icon));
    expect(widget.size, 24);
  });

  testWidgets('Correctly inherits from IconTheme', (WidgetTester tester) async {
    await tester.pumpWidget(
      Container(
        child: IconTheme(
          child: Beacon('btc'),
          data: IconThemeData(
            color: Colors.blue,
            size: 18,
          ),
        ),
      ),
    );
    final Icon widget = tester.widget(find.byType(Icon));
    expect(widget.color, Colors.blue);
    expect(widget.size, 18);
  });

  testWidgets('Overrides IconTheme', (WidgetTester tester) async {
    await tester.pumpWidget(
      Container(
        child: IconTheme(
          child: Beacon(
            'btc',
            color: Colors.red,
            size: 80,
          ),
          data: IconThemeData(
            color: Colors.blue,
            size: 18,
          ),
        ),
      ),
    );
    final Icon widget = tester.widget(find.byType(Icon));
    expect(widget.color, Colors.red);
    expect(widget.size, 80);
  });
}
