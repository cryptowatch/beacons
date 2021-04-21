import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'dart:io';

final emitter = DartEmitter();

final scssVariables = '../../dist/_variables.scss';
final outFile = './lib/beacons.g.dart';
final fontFamily = 'Beacons';

void main() async {
  var variables = await File(scssVariables).readAsLines();
  String output =
      '/// This is generated file, please to not edit by hand! \n\n/// ${'=' * 40} \n\n';

  output = '$output${BeaconGenerator.generateImports()} \n';

  int start = variables.indexOf("\$beacons: (");
  bool haveSymbolEntry = true;
  int index = start + 1;

  List<Field> fields = [];
  List<String> iconsEntries = [];

  while (haveSymbolEntry) {
    if (variables[index].contains(');')) {
      haveSymbolEntry = false;
      break;
    }
    var rawString = variables[index].substring(0, variables[index].length - 1);

    try {
      var icon = BeaconGenerator.generateIconData(rawString);

      fields.add(icon.generateSelfField());
      iconsEntries.add(icon.mapEntry);
    } on Exception catch (error, stack) {
      print(
        'A fatal name collision occured. Ignoring $rawString - this icon will not make it into the build. Error: $error, $stack',
      );
    }

    index += 1;
  }

  var iconsField = Field(
    (f) => f
      ..name = 'icons'
      ..static = true
      ..type = Reference('Map<String, IconData>')
      ..assignment = Code('{ ${iconsEntries.join(',')} }')
      ..modifier = FieldModifier.constant,
  );

  output =
      '$output\n${BeaconGenerator.generateBaseClass([iconsField, ...fields])}';

  File(outFile).writeAsString(output);
}

class BeaconGenerator {
  static _SymbolIconData generateIconData(String rawString) {
    var parts = rawString.split(':');
    var name = parts[0].trim();
    var hex = parts[1].substring(0, parts[1].length).trim();
    var iconData = _SymbolIconData(name, hex);

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

class _SymbolIconData {
  String? name;
  String? staticName;
  int? codePoint;

  _SymbolIconData(String name, String hex) {
    this.staticName = name.replaceAll('-', '_');
    this.name = _stringToName(name);
    this.codePoint = _hexToCodePoint(hex);
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
