# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Packwiz-managed Minecraft modpack. **Minecraft 1.21.1 / NeoForge 21.1.230.** 71 mods, targeting 2–4 player co-op sky-archipelago survival built around Create Aeronautics airships.

The only hand-authored content is in `datapacks/sky_aeronautics_world/`. Everything in `mods/` and `datapacks/*.pw.toml` is Packwiz metadata pointing at Modrinth/CurseForge downloads — the actual JARs are not in the repo.

## Dev environment

```bash
nix develop          # drops into shell with packwiz + jdk21 + jq
```

## Packwiz workflow

```bash
packwiz refresh                            # rebuild index.toml after editing any .pw.toml or datapack file
packwiz modrinth add <url-or-slug>         # add a mod from Modrinth (auto-creates .pw.toml + updates index.toml)
packwiz update --all                       # upgrade all mods to latest versions
packwiz curseforge add <url>               # add from CurseForge
```

**After editing any tracked file manually** (e.g. changing a JSON inside `datapacks/sky_aeronautics_world/`), you must update the hash in `index.toml` by hand OR run `packwiz refresh`. The hash format for datapack files is sha256.

```bash
sha256sum <file>   # get the hash to paste into index.toml
```

## JSON validation

```bash
python3 -m json.tool <file.json> > /dev/null
# or for all datapack JSONs at once:
find datapacks/sky_aeronautics_world/data -name '*.json' -exec python3 -m json.tool {} \; > /dev/null
```

## Datapack architecture (`datapacks/sky_aeronautics_world/`)

The datapack is manually installed into `world/datapacks/` — it is **not** downloaded by Packwiz (the `datapacks/` directory holds only `*.pw.toml` files for Packwiz-managed datapacks like `create-rubberworks-compat`, and the hand-authored folder `sky_aeronautics_world/`).

### Why `data/minecraft/dimension/overworld.json` exists

**Critical:** Terralith ships `data/minecraft/dimension/overworld.json` inside its JAR, which forces `minecraft:noise` as the overworld generator and silently overrides Sky Archipelago's world preset — even when "Sky Islands" is selected at world creation. Player-installed datapacks override mod-bundled packs in NeoForge 1.21.1, so our datapack carries its own `overworld.json` to win that priority race.

The file contains: `sky_archipelago:sky_island` generator + Terralith's full biome source (1713 biomes, extracted verbatim from the Terralith JAR). **If Terralith is updated, re-extract its biome_source and regenerate this file.**

```python
# Regenerate overworld.json after a Terralith update:
import zipfile, json
with zipfile.ZipFile('Terralith_*.jar') as z:
    tb = json.loads(z.read('data/minecraft/dimension/overworld.json'))['generator']['biome_source']
# then combine with sky_archipelago:sky_island generator block (see existing file)
```

### `data/sky_archipelago/worldgen/world_preset/sky_islands.json`

Overrides the Sky Archipelago mod's built-in world preset. Uses `sky_archipelago:sky_island` generator with three-tier island distribution (Y 64–280). Key constraint: do **not** combine `archetypes` and `island_size_bands` in the same terrain block — they are mutually exclusive in the 1.3.3 codec.

### `data/sky_archipelago/presets/`

Named preset for in-game `/skyarchipelago preset` commands. Requires `index.json` listing `{stem, name, description}` entries for the mod to recognise them.

## Mod compatibility constraints

| Mod | Constraint |
|-----|-----------|
| **sky_archipelago** (sHFNUlBU) | NeoForge-only; `SkyIslandChunkGenerator extends NoiseBasedChunkGenerator`. Namespace: `sky_archipelago:` |
| **Terralith** (8oi3bsk5) | Pure datapack (no Java). Adds biomes via explicit biome list in `data/minecraft/dimension/overworld.json` — NOT via BiomeModifier, so `preset: "minecraft:overworld"` alone won't include Terralith biomes |
| **Continents** (bQ5TJA1E) | Pure datapack; only overrides density functions. Safe alongside sky_archipelago |
| **Create Aeronautics** | Never touch Sable (physics) or Veil (rendering) configs |
| **Archipelago** (cHkXROqR) | **Wrong mod** — this is a different mod that adds islands as structures atop normal terrain. The correct mod is sky_archipelago (sHFNUlBU) |

## `index.toml` structure

Every file tracked by Packwiz must have an entry. Datapack JSON files use plain `hash` (sha256, no `metafile = true`). `.pw.toml` metadata files use `metafile = true`. Missing or wrong hashes cause Packwiz to reject the pack.

## Design principles (don't break these)

- **Pull-type flight progression**: Aeronautics airships are the endgame mobility solution. Never give permanent flight (Elytra, creative flight) in early game — it removes the incentive to build airships.
- **Sky-only world**: `ocean_enabled: false`. `forgiving_void` mod prevents void-fall death. The world has no ground; all terrain is floating islands between Y 64–280.
- **Three-tier distribution**: low band (Y ~64–160, 55% weight) is reachable by bridging; mid band needs gliding/ballooning; high band (~260+) effectively requires Aeronautics.
- **pack_format for 1.21.1 datapacks**: `48`
