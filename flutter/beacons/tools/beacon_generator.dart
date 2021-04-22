import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import './constants.dart';

final emitter = DartEmitter();

class BeaconGenerator {
  static SymbolIconData generateIconData(String rawString) {
    var parts = rawString.split(':');
    var name = parts[0].trim();
    var hex = parts[1].substring(0, parts[1].length).trim();
    var iconData = SymbolIconData(name, hex);

    return iconData;
  }

  static String generateImports() {
    final library = Library(
      (b) => b.body.addAll([
        Directive.import('package:flutter/widgets.dart'),
      ]),
    );

    return DartFormatter().format('${library.accept(emitter)}');
  }

  static String generateBaseClass(List<Field> fields) {
    final c = Class(
      (b) => b
        ..name = '$fontFamily'
        ..fields.addAll(
          [
            Field(
              (updates) => updates
                ..name = 'family'
                ..static = true
                ..assignment = Code('"$fontFamily"')
                ..modifier = FieldModifier.constant,
            ),
            Field(
              (updates) => updates
                ..name = 'pkg'
                ..static = true
                ..assignment = Code('null')
                ..modifier = FieldModifier.constant,
            ),
            ...fields,
          ],
        ),
    );
    return DartFormatter().format('${c.accept(emitter)}');
  }
}

Map<String, bool> conflicts = {};

class SymbolIconData {
  String? name;
  String? staticName;
  String? codePoint;

  SymbolIconData(String name, String hex) {
    this.staticName = name.replaceAll('-', '_');
    this.name = _stringToName(name);
    this.codePoint = '0x$hex';
    // _hexToCodePoint(hex);
  }

  static int _hexToCodePoint(String hex) {
    return int.parse('0x$hex');
  }

  Code _code() {
    return Code(
      'IconData(${this.codePoint}, fontFamily: family, fontPackage: pkg,)',
    );
  }

  String _stringToName(String name) {
    if (conflicts[name] != null ||
        name.contains('.') ||
        name.contains('\"') ||
        name.contains('\'')) {
      throw Exception('Unavoidable name conflict');
    }

    var idealName = name.split('-').sublist(1).join('-');

    if (conflicts[idealName] != null && conflicts[idealName] == true) {
      conflicts[name] = true;
      return name;
    } else {
      conflicts[idealName] = true;
      return idealName;
    }
  }

  String get mapEntry {
    return "'$name': $fontFamily.$staticName";
  }

  Field generateSelfField() {
    return Field(
      (f) => f
        ..static = true
        ..name = staticName
        ..modifier = FieldModifier.constant
        ..assignment = _code(),
    );
  }

  @override
  String toString() {
    return '$name, $staticName, $codePoint';
  }
}
