import 'package:code_builder/code_builder.dart';
import 'dart:io';

import './beacon_generator.dart';
import './constants.dart';

void main() async {
  String output =
      '/// Warning: This is generated file, please to not edit. \n\n/// ${'=' * 40} \n\n';

  output = '$output${BeaconGenerator.generateImports()} \n';

  var variables = await File(scssVariables).readAsLines();

  List<Field> fields = [];
  List<String> iconsEntries = [];
  List<SymbolIconData> iconData = parseVariablesScssToIconData(variables);

  for (var icon in iconData) {
    fields.add(icon.generateSelfField());
    iconsEntries.add(icon.mapEntry);
  }

  var iconsStringToDataMap = Field(
    (f) => f
      ..name = 'icons'
      ..static = true
      ..type = Reference('Map<String, IconData>')
      ..assignment = Code('{ ${iconsEntries.join(',')} }')
      ..modifier = FieldModifier.constant,
  );

  fields.insert(0, iconsStringToDataMap);

  output = '$output\n${BeaconGenerator.generateBaseClass(fields)}';

  File(outFile).writeAsString(output);
}

List<SymbolIconData> parseVariablesScssToIconData(List<String> variables) {
  int start = variables.indexOf("\$beacons: (");

  bool haveSymbolEntry = true;
  List<SymbolIconData> iconData = [];

  int index = start + 1;
  while (haveSymbolEntry) {
    if (variables[index].contains(');')) {
      haveSymbolEntry = false;
      break;
    }
    var rawString = variables[index].substring(0, variables[index].length - 1);

    try {
      var icon = BeaconGenerator.generateIconData(rawString);
      iconData.add(icon);
    } on Exception catch (error, stack) {
      print(
        'A fatal name collision occured. Ignoring $rawString - this icon will not make it into the build. Error: $error, $stack',
      );
    }

    index += 1;
  }

  return iconData;
}
