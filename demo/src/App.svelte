<script>
  import beacons from "../src/assets/beacons.json";
  import beaconNames from "../src/assets/beaconNames.json";

  const beaconKeys = Object.keys(beacons);

  let query = "";
  let filters = { exchanges: true, symbols: true };

  const filterFun = {
    exchanges: (key) => key.slice(0, 4) === "exc-",
    symbols: (key) => key.slice(0, 4) === "sym-",
  };

  const iconsPerFilter = {};
  Object.keys(filterFun).forEach((filter) => {
    Object.assign(iconsPerFilter, {
      [filter]: beaconKeys.filter(filterFun[filter]).length,
    });
  });

  $: filterKeys = Object.keys(filterFun).filter((key) => filters[key]);

  $: filtered = beaconKeys.filter((item) => {
    return filterKeys.some((key) => {
      return filterFun[key](item);
    });
  });

  $: nIcons = Object.entries(filtered).length;

  $: filteredBeacons = filtered.filter((key) => {
    const q = query.toLowerCase();
    const sym = syms[key];
    const name = beaconNames[sym].toLowerCase();
    return sym.includes(q) || name.includes(q);
  });

  const getMiddlePart = (beacon) => {
    const middle = beacon.slice(4);
    return hasPostfix(beacon) ? middle.slice(0, -2) : middle;
  };

  const groupTest = (beacon) => {
    const i = beaconKeys.indexOf(beacon);
    if (i < 1) return false;
    const prevBeacon = beaconKeys[i - 1];
    // console.log(prevBeacon);
    const start = prevBeacon.slice(0, -2);
    const isGroup = start === beacon && hasPostfix(prevBeacon);
    return !!isGroup;
  };

  const hasPostfix = (beacon) => beacon.slice(beacon.length - 2) === "-s";

  const syms = {};
  const names = {};
  const groups = {};
  beaconKeys.forEach((beacon) => {
    const sym = getMiddlePart(beacon);
    const name = beaconNames[sym] ? beaconNames[sym] : sym;
    const group = groupTest(beacon);
    Object.assign(syms, { [beacon]: sym });
    Object.assign(names, { [beacon]: name });
    Object.assign(groups, { [beacon]: group });
  });
  console.log(groups);
</script>

<div class="container">
  <h1>Beacons</h1>
  <p>
    Crypto icon font by
    <a href="https://cryptowat.ch" target="_blank" rel="noopener noreferrer"
      >Cryptowatch</a
    >
    (<a
      href="https://github.com/cryptowatch/beacons"
      target="_blank"
      rel="noopener noreferrer">GitHub</a
    >)
  </p>
  <input
    type="text"
    bind:value={query}
    placeholder={`Search ${nIcons} icons`}
  />
  <div class="filters">
    {#each Object.keys(filters) as filter}
      <div class="filter">
        <input type="checkbox" bind:checked={filters[filter]} id={filter} />
        <label for={filter}>{`${filter} (${iconsPerFilter[filter]})`}</label>
      </div>
    {/each}
  </div>
  <div class="beacons-flex">
    {#each filteredBeacons as beacon, i}
      {#if groups[beacon]}
        <div class="beacon-container">
          <div class="name">{names[beacon]}</div>
          <div class="icon">
            <i class={`beacon-${beacon}`} />
            <div class="text">
              <span class="prefix">{beacon.slice(0, 4)}</span><span class="main"
                >{syms[beacon]}</span
              >{#if hasPostfix(beacon)}<span class="postfix">-s</span>{/if}
            </div>
          </div>
          <div class="icon">
            <i class={`beacon-${filteredBeacons[i - 1]}`} />
            <div class="text">
              <span class="prefix">{filteredBeacons[i - 1].slice(0, 4)}</span
              ><span class="main">{syms[filteredBeacons[i - 1]]}</span
              >{#if hasPostfix(filteredBeacons[i - 1])}<span class="postfix"
                  >-s</span
                >{/if}
            </div>
          </div>
        </div>
      {/if}
    {:else}
      <div>No results.</div>
    {/each}
  </div>
</div>

<style type="text/scss">
  .container {
    max-width: 960px;
    margin: 0 auto;
    padding: 16px;
    input[type="text"] {
      font-family: "Iosevka Custom Web", monospace;
      width: 100%;
      background-color: transparent;
      color: var(--text);
      padding: 4px 8px;
      border: 1px solid var(--border);
      font-size: 16px;
      max-width: 300px;
      &:focus {
        outline: 0;
        border-color: var(--text);
      }
      &::placeholder {
        color: var(--weak);
      }
    }
    .filters {
      display: flex;
      margin: 0 -8px;
      .filter {
        padding: 8px;
        label {
          text-transform: capitalize;
        }
      }
      margin-bottom: 32px;
    }
    .beacons-flex {
      display: grid;
      grid-gap: 8px;
      grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
      &::after {
        content: "";
        flex: auto;
      }
      .beacon-container {
        display: grid;
        grid-template-columns: 1fr;
        grid-gap: 8px;
        padding: 8px;
        background-color: var(--bg-light);
        .name {
          font-weight: 700;
        }
        .icon {
          display: flex;
          align-items: center;
          i {
            margin-right: 8px;
            font-size: 40px;
            color: var(--text);
          }
          .text {
            color: var(--weak);
            text-align: left;
            .main {
              color: var(--text);
            }
          }
        }
      }
    }
  }
</style>
