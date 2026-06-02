PlayerEvents.loggedIn(event => {
  const player = event.player
  const data = player.persistentData

  if (data.contains('sky_rescue_kit_given')) return

  data.putBoolean('sky_rescue_kit_given', true)

  player.give(Item.of('minecraft:wooden_pickaxe'))
  player.give(Item.of('minecraft:wooden_axe'))
  player.give(Item.of('minecraft:wooden_shovel'))
  player.give(Item.of('minecraft:ender_pearl', 4))
  player.give(Item.of('minecraft:bread', 6))
  player.give(Item.of('minecraft:white_wool', 32))
  player.give(Item.of('minecraft:torch', 16))
  player.give(Item.of('minecraft:water_bucket'))
  player.give(Item.of('minecraft:lava_bucket'))
  player.give(Item.of('patchouli:guide_book[patchouli:book="patchouli:guide"]'))
})
