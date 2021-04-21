import 'package:flutter_test/flutter_test.dart';

import 'package:beacons/beacons.dart' show Beacons;

void main() {
  test('Uses correct fontFamily', () {
    expect(Beacons.family, 'Beacons');
  });
}
