library beacons;

import 'package:flutter/widgets.dart';
import 'beacons.g.dart';

/// A simple extension class on [Icon] that maps a [String] from the Cryptowatch
/// API and returns an Icon.
///
/// Accepts all the same named arguments as [Icon].
class Beacon extends Icon {
  final Key? key;
  final Color? color;
  final double size;
  final String semanticLabel;
  final TextDirection textDirection;

  Beacon(
    String crypton, {
    this.key,
    this.color,
    bool symbol = true,
    this.size = 18,
    this.semanticLabel = '',
    this.textDirection = TextDirection.ltr,
  }) : super(
          Beacons.icons.containsKey(crypton)
              ? Beacons.icons['$crypton${symbol ? '-s' : ''}']
              : symbol
                  ? Beacons.sym_default
                  : Beacons.sym_default_s,
          key: key,
          size: size,
          color: color,
          semanticLabel: semanticLabel,
          textDirection: textDirection,
        );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2),
      child: Icon(
        this.icon,
        size: this.size,
        color: this.color,
        semanticLabel: this.semanticLabel,
        textDirection: this.textDirection,
      ),
    );
  }
}
