# SVG Beacons

## Install dependencies

```
npm i
```

## Build font files

Generate font files in `/dist` from svg files in `/src` by running:

```
npm run font
```

## Build your own custom font

Only include the icons you want included in your custom font in the `/src` folder. Run

```
npm run font
```

to build your custom font. Beacons uses `Fantasticon` to build the font. You can customize the build by modifying the `makeFont.js` file in the `/scripts` folder.

## SVG rules

The SVG markup should look like this:

```
<svg xmlns="http://www.w3.org/2000/svg" width="1000" height="1000">
  <path d="M840.584 550.432H621.415c0-24.905-2.49-42.339-6.226-69.735-23.66-156.905-114.566-265.245-236.603-348.678C278.963 66.019 239.114 57.302 153.19 5h405.961c17.434 0 26.151 2.49 38.604 13.698 145.698 132 242.83 296.377 249.056 498.112v26.15s0 7.472-6.227 7.472zm-537.96 444.565v-625.13c93.396 155.66 184.3 308.83 273.961 459.508-89.66 54.792-180.565 105.849-273.961 165.622z" style="fill:#000;fill-opacity:1;fill-rule:nonzero;stroke:none;"/>
</svg>
```

- The SVG should only contain one path

- Width and height of the SVG should be set to 1000x1000px

- The icon should be vertically and horizontally centered

- The icon should take up the maximum amount of space of the artboard (0 padding)

- The path's decimal precision should be 3
