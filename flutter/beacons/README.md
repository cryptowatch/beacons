# Cryptowatch Beacons

A beautiful crypto font pack for Flutter by Cryptowatch.

## Getting Started

Install beacons from pub.dev and import.

`import 'package:beacons/beacons.dart'`

`Beacon` extends `Icon` and can be rendered anywhere an `Icon` can be rendered.

### `Beacon` Usage

Simply:

```
Beacon('btc');
```

Change size/color of the icon:

```
Beacon('btc', size: 12, color: Colors.orange);
```

Use a circular icon style.

```
Beacon('btc', symbol: false);
```

### Using `Beacons` instead

You might want to pass one of the static `Beacons` properties to `Icon` for more control, or so that you don't rely on strings. You can accomplish this as follows:

`Icon(Beacons.sym_btc)`
