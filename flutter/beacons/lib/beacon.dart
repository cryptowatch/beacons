import 'package:flutter/widgets.dart';
import 'beacons.g.dart';

/// A simple extension class on [Icon] that maps a [String] from the Cryptowatch
/// API and returns an Icon.
///
/// Accepts all the same named arguments as [Icon].
class Beacon extends Icon {
  /// Optional Flutter key.
  final Key? key;

  /// Override default [Icon] color.
  final Color? color;

  /// Override default `size` of `18`.
  final double size;

  /// Semantic label as per [Icon].
  final String semanticLabel;

  /// [TextDirection] override as per [Icon]
  final TextDirection textDirection;

  /// Creates a Cryptowatch Beacon icon using a [String] symobl representing
  /// either a. A cryptocurrency (eg. `btc`, `eth`, `doge`),
  /// b. An exchange (eg. `kraken`, `binance`),
  /// c. A currency (eg. `usd`, `jpy`, `euro`).
  Beacon(
    /// A string representing a crypto/exchange/currency. See [Beacons] `icons` map
    /// for options. Optionally you can reference any of the static properties in
    /// [Beacons] and pass that to [Icon] eg `Icon(Beacons.sym_btc)`
    String name, {
    this.key,
    this.color,
    bool symbol = true,
    this.size = 18,
    this.semanticLabel = '',
    this.textDirection = TextDirection.ltr,
  }) : super(
          Beacons.icons.containsKey(name)
              ? Beacons.icons['$name${symbol ? '-s' : ''}']
              : symbol
                  ? Beacons.sym_default
                  : Beacons.sym_default_s,
          key: key,
          size: size,
          color: color,
          semanticLabel: semanticLabel,
          textDirection: textDirection,
        );

  /// A [Beacon] constructor that will fallback to the default `currency` icon.
  Beacon.currency(
    String name, {
    this.key,
    this.color,
    bool symbol = true,
    this.size = 18,
    this.semanticLabel = '',
    this.textDirection = TextDirection.ltr,
  }) : super(
          Beacons.icons.containsKey(name)
              ? Beacons.icons['cur-$name${symbol ? '-s' : ''}']
              : symbol
                  ? Beacons.cur_default
                  : Beacons.cur_default_s,
          key: key,
          size: size,
          color: color,
          semanticLabel: semanticLabel,
          textDirection: textDirection,
        );

  /// A [Beacon] constructor that will fallback to the default `currency` icon.
  Beacon.exchange(
    String name, {
    this.key,
    this.color,
    bool symbol = true,
    this.size = 18,
    this.semanticLabel = '',
    this.textDirection = TextDirection.ltr,
  }) : super(
          Beacons.icons.containsKey(name)
              ? Beacons.icons['exc-$name${symbol ? '-s' : ''}']
              : symbol
                  ? Beacons.exc_default
                  : Beacons.exc_default_s,
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
