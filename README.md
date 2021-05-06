# Cryptowatch Beacons

Cryptowatch Beacons is a crypto icon font that contains over 1800 icons of cryptocurrencies, crypto exchanges and fiat currencies.

<img src="https://raw.githubusercontent.com/cryptowatch/beacons/master/img/beaconTop.png">

## Live Demo

https://cryptowatch.github.io/beacons

## Usage

Import the files in the `/dist` folder into your project and link to `beacons.css`:

`<link rel="stylesheet" href="beacons.css">`

You may need to adapt the href value to your project's folder structure. Now you can start to use the font:

`<i class="beacon-sym-btc" />`

All icons have 2 versions: By default they are surrounded by a circle. Simply add the `-s` postfix to get the icon without the surrounding circle:

`<i class="beacon-sym-btc-s" />`

<img src="https://raw.githubusercontent.com/cryptowatch/beacons/master/img/iconExample.png">

### Groups

The font consists of 2 icon groups:

- Exchanges (`exc-` prefix)
- Symbols (`sym-` prefix)

For example, if you want to display the icon for the Kraken exchange, you would do:

`<i class="beacon-exc-kraken" />`

or

`<i class="beacon-exc-kraken-s" />`

### Fallback

`beacon-sym-default` can be used as a fallback for non-existing icons. You could do:

`<i class="beacon-sym-default beacon-sym-NONEXISTANT" />`

if `beacon-sym-NONEXISTANT` does not exist, `beacon-sym-default` will be used instead.

# Build your own custom font

## Install dependencies

```
npm i
```

Only include the icons you want included in your custom font in the `/src` folder. Run

```
npm run build
```

to build your custom font (output in `/dist`).

Beacons uses `Fantasticon` to build the font. You can customize the build by modifying the `build.js` file in the `/scripts` folder.
