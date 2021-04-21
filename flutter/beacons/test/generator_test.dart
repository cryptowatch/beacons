import 'package:flutter_test/flutter_test.dart';

import '../generator.dart';

const List<String> testInputs = [
  'sym-default: f002',
  'sym-default-s: e002',
  'exc-vaultofsatoshi: f11d',
  'exc-vaultofsatoshi-s: e11d',
  'cur-default: f200',
  'cur-default-s: e200',
  'sym-btc: f01e',
  'sym-btc-s: e01e',
];

const testResults = [
  ['sym_default', 'default', 0xf002],
  ['sym_default_s', 'default-s', 0xe002],
  ['exc_vaultofsatoshi', 'vaultofsatoshi', 0xf11d],
  ['exc_vaultofsatoshi_s', 'vaultofsatoshi-s', 0xe11d],
  ['cur_default', 'cur-default', 0xf200],
  ['cur_default_s', 'cur-default-s', 0xe200],
  ['sym_btc', 'btc', 0xf01e],
  ['sym_btc_s', 'btc-s', 0xe01e],
];

void main() {
  tearDown(() {
    conflicts = {};
  });

  test('Correctly converts SCSS strings to SymbolIconData', () {
    for (var i = 0; i < testInputs.length; i += 1) {
      var iconData = BeaconGenerator.generateIconData(testInputs[i]);
      var matcher = testResults[i];
      expect(iconData.staticName, matcher[0]);
      expect(iconData.name, matcher[1]);
      expect(iconData.codePoint, matcher[2]);
    }
  });

  test('Handles unique name clashes', () {
    var clashing1 = 'sym-default: f033';
    var clashing2 = 'cur-default: e033';
    var clashing3 = 'exc-default: e033';
    var iconData = BeaconGenerator.generateIconData(clashing1);
    var iconData2 = BeaconGenerator.generateIconData(clashing2);
    var iconData3 = BeaconGenerator.generateIconData(clashing3);

    expect(iconData.name, 'default');
    expect(iconData2.name, 'cur-default');
    expect(iconData3.name, 'exc-default');
  });

  test('Ignores duplicate name clashes', () {
    var clashing1 = 'sym-default: f033';
    var clashing2 = 'cur-default: e033';
    var clashing3 = 'cur-default: e033';
    var iconData = BeaconGenerator.generateIconData(clashing1);
    var iconData2 = BeaconGenerator.generateIconData(clashing2);

    expect(iconData.name, 'default');
    expect(iconData2.name, 'cur-default');
    expect(() => BeaconGenerator.generateIconData(clashing3), throwsException);
  });

  test('Ignores novel naming', () {
    var clashing1 = '"sym-eth2s": f033';
    var clashing2 = 'sym-eth2.s: e033';

    expect(() => BeaconGenerator.generateIconData(clashing1), throwsException);
    expect(() => BeaconGenerator.generateIconData(clashing2), throwsException);
  });
}
