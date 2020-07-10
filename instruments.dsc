## Instruments
## By: princil

## Configuration:
instruments_config:
  type: data
  # Can players use instruments to craft items? [default=false]
  can_craft: false
  # Can players hurt entities using instruments? [default=true]
  can_damage: true
  # Can players break blocks using instruments? [default=true]
  can_break: true

## To add your own items, copy-paste the commented (green) text below the other items, remove each # from the copied text, and fill in the {item_name}, {material}, {sound} and {item_display_name} values.

#{item_name}:
#  type: item
#  material: {material}
#  mechanisms:
#    nbt: sound/{sound}
#  display name: <&r>{item_display_name}
#  debug: false

## Items
basedrum:
  type: item
  material: leather
  mechanisms:
    nbt: sound/block_note_block_basedrum
  display name: <&r>Drum
  recipes:
    1:
      type: shaped
      input:
      - leather|leather|leather
      - leather|oak_planks/birch_planks/spruce_planks/jungle_planks/acacia_planks/dark_oak_planks|leather
      - oak_planks/birch_planks/spruce_planks/jungle_planks/acacia_planks/dark_oak_planks|oak_planks/birch_planks/spruce_planks/jungle_planks/acacia_planks/dark_oak_planks|oak_planks/birch_planks/spruce_planks/jungle_planks/acacia_planks/dark_oak_planks
  debug: false
bell:
  type: item
  material: gold_ingot
  mechanisms:
    nbt: sound/block_note_block_bell
  display name: <&r>Bell
  recipes:
    1:
      type: shaped
      input:
      - air|gold_nugget|air
      - gold_ingot|gold_ingot|gold_ingot
      - gold_ingot|gold_nugget|gold_ingot
  debug: false
flute:
  type: item
  material: stick
  mechanisms:
    nbt: sound/block_note_block_flute
  display name: <&r>Flute
  recipes:
    1:
      type: shaped
      input:
      - air|air|dark_oak_planks
      - air|dark_oak_planks|air
      - birch_planks|air|air
  debug: false
guitar:
  type: item
  material: stick
  mechanisms:
    nbt: sound/block_note_block_guitar
  display name: <&r>Guitar
  recipes:
    1:
      type: shaped
      input:
      - air|string|oak_planks/birch_planks/spruce_planks/jungle_planks/acacia_planks/dark_oak_planks|oak_planks/birch_planks/spruce_planks/jungle_planks/acacia_planks/dark_oak_planks
      - oak_planks/birch_planks/spruce_planks/jungle_planks/acacia_planks/dark_oak_planks|oak_planks/birch_planks/spruce_planks/jungle_planks/acacia_planks/dark_oak_planks|oak_planks/birch_planks/spruce_planks/jungle_planks/acacia_planks/dark_oak_planks|oak_planks/birch_planks/spruce_planks/jungle_planks/acacia_planks/dark_oak_planks|string
      - oak_planks/birch_planks/spruce_planks/jungle_planks/acacia_planks/dark_oak_planks|oak_planks/birch_planks/spruce_planks/jungle_planks/acacia_planks/dark_oak_planks|oak_planks/birch_planks/spruce_planks/jungle_planks/acacia_planks/dark_oak_planks|oak_planks/birch_planks/spruce_planks/jungle_planks/acacia_planks/dark_oak_planks|string
  debug: false
harp:
  type: item
  material: gold_ingot
  mechanisms:
    nbt: sound/block_note_block_harp
  display name: <&r>Harp
  recipes:
    1:
      type: shaped
      input:
      - gold_ingot|gold_ingot|gold_ingot
      - gold_ingot|string|gold_ingot
      - gold_ingot|string|gold_ingot
  debug: false
xylophone:
  type: item
  material: bone
  mechanisms:
    nbt: sound/block_note_block_xylophone
  display name: <&r>Bone Xylophone
  recipes:
    1:
      type: shaped
      input:
      - bone|air|bone
      - bone|bone|air
      - air|bone|bone
  debug: false
snare:
  type: item
  material: leather
  mechanisms:
    nbt: sound/sound/block_note_block_snare
  display name: <&r>Short Drum
  recipes:
    1:
      type: shaped
      input:
      - leather|leather
      - oak_planks/birch_planks/spruce_planks/jungle_planks/acacia_planks/dark_oak_planks|oak_planks/birch_planks/spruce_planks/jungle_planks/acacia_planks/dark_oak_planks
  debug: false

## Handlers
instrument_handler:
  type: world
  debug: false
  events:
    on player breaks block:
    - if <player.item_in_hand.has_nbt[sound]> && !<script[instruments_config].data_key[can_break]>:
      - determine passively cancelled
    on item recipe formed:
    - if <script[instruments_config].data_key[can_craft]>:
      - stop
    - foreach <context.recipe>:
      - if <[value].has_nbt[sound]>:
        - determine cancelled
    after player right clicks entity with item:
    - flag player pitches_r d:2t
    - inject instrument_task
    after player left clicks with item:
    - flag player pitches_l d:2t
    - inject instrument_task
    after player right clicks with item:
    - flag player pitches_r d:2t
    - inject instrument_task
    after player damages entity:
    - if <player.item_in_hand.has_nbt[sound]> && !<script[instruments_config].data_key[can_damage]>:
      - determine passively cancelled
    - flag player pitches_l d:2t
    - inject instrument_task
instrument_task:
  type: task
  debug: false
  script:
  - if !<player.item_in_hand.has_nbt[sound]>:
    - stop
  - if <player.open_inventory.inventory_type> != CRAFTING:
    - stop
  - if <player.has_flag[instrument_cooldown]>:
    - stop
  - flag player instrument_cooldown d:1t
  - if <player.has_flag[pitches_l]>:
    - define pitch <element[1.05946].power[<player.location.pitch.sub[90].mul[-1].mul[<element[12].div[180]>].round>].div[2]>
  - else if <player.has_flag[pitches_r]>:
    - define pitch <element[1.05946].power[<player.location.pitch.sub[90].mul[-1].mul[<element[12].div[180]>].round.add[12]>].div[2]>
    - determine passively cancelled
    - if <player.item_in_hand.has_nbt[custom]>:
      - playsound <player.location> sound:<player.item_in_hand.nbt[sound]> pitch:<[pitch]> custom sound_category:records
    - else:
      - playsound <player.location> sound:<player.item_in_hand.nbt[sound]> pitch:<[pitch]> sound_category:records
    - playeffect effect:NOTE at:<player.location.add[0,2,0].add[<util.random.decimal[-0.5].to[0.5]>,<util.random.decimal[0].to[0.5]>,<util.random.decimal[-0.5].to[0.5]>]> offset:<[pitch]>,0,0 quantity:0 data:1