const fs = require("fs");

import beacons from "../dist/beacons.json";

const hexObj = {};

Object.keys(beacons).forEach((key) => {
  const hex = beacons[key].toString(16);
  Object.assign(hexObj, { [key]: hex });
});

fs.writeFile(
  "demo/src/assets/beacons.json",
  JSON.stringify(hexObj, null, 2),
  (err) => {
    if (err) throw err;
  }
);
