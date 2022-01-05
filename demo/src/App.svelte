<script>
  import { onDestroy } from "svelte";
  import { fade } from "svelte/transition";
  import beacons from "../src/assets/beacons.json";
  import beaconNames from "../src/assets/beaconNames.json";
  import map from "../../map/map.json";

  const hasPostfix = (beacon) => beacon.slice(beacon.length - 2) === "-s";

  const getMiddlePart = (beacon) => {
    const middle = beacon.slice(4);
    return hasPostfix(beacon) ? middle.slice(0, -2) : middle;
  };

  const exclude = ["b", "d", "default", "_default"];

  const beaconKeys = Object.keys(beacons).filter(
    (beacon) => !exclude.includes(getMiddlePart(beacon))
  );

  let query = "";

  const filtered = beaconKeys.filter((beacon) => !hasPostfix(beacon));

  $: filteredBeacons = filtered.filter((key) => {
    const q = query.toLowerCase();
    const sym = syms[key];
    const name = beaconNames[sym]?.toLowerCase();
    return sym.includes(q) || name?.includes(q);
  });

  const syms = {};
  const names = {};
  beaconKeys.forEach((beacon) => {
    const sym = getMiddlePart(beacon);
    const name = beaconNames[sym] ? beaconNames[sym] : sym;
    syms[beacon] = sym;
    names[beacon] = name;
  });

  let to;
  let showCopiedMsg = false;
  let copyErr = false;

  const getSVG = async (beacon) => {
    clearTimeout(to);
    showCopiedMsg = false;
    copyErr = false;
    if (beacon in map) beacon = map[beacon];
    try {
      const res = await fetch(
        `https://raw.githubusercontent.com/cryptowatch/beacons/master/src/${beacon}.svg`
      );
      if (res.ok) {
        const text = await res.text();
        navigator.clipboard.writeText(text);
      } else {
        copyErr = true;
      }
    } catch (e) {
      copyErr = true;
    }
    showCopiedMsg = true;
    to = setTimeout(() => (showCopiedMsg = false), 1000);
  };

  onDestroy(() => clearTimeout(to));

  let innerHeight, clientHeight;
</script>

{#if showCopiedMsg}
  <div class="copy-msg" transition:fade|local={{ duration: 100 }}>
    {#if copyErr}
      Error
    {:else}
      SVG markup copied to clipboard
    {/if}
  </div>
{/if}

<svelte:window bind:innerHeight />

<div class="container">
  <div bind:clientHeight>
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
    <p class="secondary">
      Click on an icon to copy its SVG markup to your clipboard
    </p>
    <input
      type="text"
      bind:value={query}
      placeholder={`Search ${beaconKeys.length} icons`}
      spellcheck="false"
    />
  </div>
  <div
    class="beacons-flex"
    style="max-height: {innerHeight - clientHeight - 16}px;"
  >
    {#each filteredBeacons as beacon}
      <div class="beacon-container">
        <div class="name">{names[beacon]}</div>
        <div class="icon">
          {#if beaconKeys.includes(beacon)}
            <i class={`beacon ${beacon}`} on:click={getSVG(beacon)} />
            <div class="text">
              <span class="prefix">{beacon.slice(0, 4)}</span><span class="main"
                >{syms[beacon]}</span
              >
            </div>
          {/if}
        </div>
        <div class="icon">
          {#if beaconKeys.includes(`${beacon}-s`)}
            <i class={`beacon ${beacon}-s`} on:click={getSVG(`${beacon}-s`)} />
            <div class="text">
              <span class="prefix">{beacon.slice(0, 4)}</span><span class="main"
                >{syms[beacon]}</span
              ><span class="postfix">-s</span>
            </div>
          {/if}
        </div>
      </div>
    {:else}
      <div>No results.</div>
    {/each}
  </div>
</div>

<style type="text/scss">
  .copy-msg {
    position: fixed;
    top: 16px;
    background-color: var(--alert);
    color: var(--bg);
    padding: 8px;
    left: 50%;
    transform: translateX(-50%);
  }
  .container {
    max-width: 960px;
    margin: 0 auto;
    padding: 16px 16px 0 16px;
    h1 {
      font-size: 16px;
      margin-block-start: 0;
      margin-block-end: 8px;
    }
    p {
      margin-block-start: 0;
      margin-block-end: 8px;
    }
    input[type="text"] {
      font-family: "Iosevka Custom Web", monospace;
      width: calc(100% - 16px);
      background-color: transparent;
      color: var(--text);
      padding: 4px 8px;
      border: 1px solid var(--border);
      font-size: 20px;
      margin-bottom: 16px;
      &:focus {
        outline: 0;
        border-color: var(--text);
      }
      &::placeholder {
        color: var(--weak);
      }
    }
    .secondary {
      color: var(--weak);
      font-size: 14px;
    }
    .beacons-flex {
      overflow: auto;
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
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }
        .icon {
          display: flex;
          align-items: center;
          min-height: 40px;
          i {
            margin-right: 8px;
            height: 40px;
            width: 40px;
            font-size: 40px;
            color: var(--text);
            cursor: pointer;
            &:hover {
              color: var(--alert);
            }
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
