const fs = require("fs");

import map from "../map/map.json";
import beacons from "../dist/beacons.json";

const css = Object.keys(map)
  .map((key) => {
    const value = map[key];
    const hex = beacons[value].toString(16);
    return `.beacon-${key}:before {\n    content: "\\${hex}"\n}`;
  })
  .join("\n");

fs.writeFile("map/map.css", css, (err) => {
  if (err) throw err;
});
