# Sky Aeronautics Rescue System

Supplemental datapack that adds essential survival resources to floating-island worlds.
Does not modify terrain generation — it overlays features on top of sky_aeronautics_world.

## What this adds

| Layer | Content |
|-------|---------|
| Worldgen | Coal/iron/copper ore veins in island stone (Y 64-160/180) |
| Worldgen | Lava spring (Y 64-140) — Nether access without a natural lava pool |
| First-join kit | Wooden tools, ender pearls, bread, white wool, torches, water bucket, lava bucket |

## First-join kit

Delivered once per player via `kubejs/server_scripts/starter_kit.js`.
Uses `player.persistentData` key `sky_rescue_kit_given` — survives server restarts.

**Reset a player's kit** (server console):
```
/data remove entity <player> ForgeCaps...
```
Or delete the player's `.dat` file in `world/playerdata/` while the server is stopped.

Simpler reset: edit NBT with a tool like NBTExplorer and delete the `sky_rescue_kit_given` key.

## Adjusting ore counts

Edit the `count` value in the relevant `placed_feature` JSON:
- `ore_coal_island.json` — default 12 veins/chunk
- `ore_iron_island.json` — default 8 veins/chunk
- `ore_copper_island.json` — default 6 veins/chunk
- `lava_spring_island.json` — default 1 per chunk (keep low — one lava source is enough)

After editing, update the hash in `index.toml` and `pack.toml`.

## Adjusting ore height

Edit `min_inclusive` / `max_inclusive` in the placed_feature `height_range` block.
Current ranges are capped at Y 64-160 (near-layer only) so ores don't appear on high-altitude islands.

## Testing checklist

1. Load a new world with both datapacks installed.
2. Log in as a fresh player — kit should appear in inventory.
3. Log out and back in — kit must NOT be granted again.
4. Have a second player join for the first time — they get their own kit.
5. Mine island stone — coal/iron/copper veins should be visible.
6. Find a lava spring on a low-altitude island (Y ~64-140).

## Scope notes

- No permanent flight items (Elytra etc.) — would break the pull-type Aeronautics design.
- Spawn island guarantee is handled by sky_archipelago's SkyIslandSpawnFallback (automatic).
- ForcedIslandRegistry is Java API only — cannot be configured via datapack.
