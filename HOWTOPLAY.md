# Fractiwi
### Version a1.0
## Overview

### Exploration
You control a young child who is stuck within their subconscious. Their dreamworld is a web of many different areas containing hostile enemies. While you can explore at your own leisure, you will need to collect every [effect](#effects) in order to free yourself. These items are hidden within rooms and protected by powerful creatures.

### Combat
When you make contact with an enemy in the overworld, you are thrown into turn-based combat. Through [recruiting](#recruiting) or [fusing](#fusion), you can create a custom party for battle. Use skills that hit the weaknesses in your enemies' [defensive affinities](#affinities) or change your own to nullify your enemies' skills in order to gain control of a battle.

## Gameplay Mechanics

### Affinities
Every creature has its own set of defensive and offensive affinities. Defensive (labeled DEF in-game) affinities dictate what type of attacks are strong or weak on a creature. Offensive affinities (labeled OFF in-game) modify the effectiveness of different types of skills.

#### Defensive affinities (OFF)
Experimenting with the weaknesses or resistances of creatures is crucial for success in battle. Some affinities allow you to remove turns from your opponents or gain more for yourself.

In-game abbreviation | Name | Damage modifier | Turn Press modifier
--- | --- | --- | --- 
rs | Resist | x0.5 | No effect
wk | Weak | x2.0 | Grants half turn icon
rp | Repel | x1.0 | Removes all turn press icons
ab | Absorb | x1.0 | Removes two turn press icons
nu | Null | x0.0 | Removes two turn press icons

#### Offensive affinities (DEF)
Offensive affinities range from -8 to 8. Every stage is +/-10% damage when using that type of skill 

#### Skill types
Name | Icon
--- | ---
Phys | ![Image of Turn Press icons](main/ui/menu/game_menu/party_skill_container/skill_button_container/skill_button_panel/affinity_icons/phys.png?raw=true)
Fire | ![Image of Turn Press icons](main/ui/menu/game_menu/party_skill_container/skill_button_container/skill_button_panel/affinity_icons/fire.png?raw=true)
Water | ![Image of Turn Press icons](main/ui/menu/game_menu/party_skill_container/skill_button_container/skill_button_panel/affinity_icons/water.png?raw=true)
Elec | ![Image of Turn Press icons](main/ui/menu/game_menu/party_skill_container/skill_button_container/skill_button_panel/affinity_icons/elec.png?raw=true)
Wind | ![Image of Turn Press icons](main/ui/menu/game_menu/party_skill_container/skill_button_container/skill_button_panel/affinity_icons/wind.png?raw=true)
Light | ![Image of Turn Press icons](main/ui/menu/game_menu/party_skill_container/skill_button_container/skill_button_panel/affinity_icons/light.png?raw=true)
Dark | ![Image of Turn Press icons](main/ui/menu/game_menu/party_skill_container/skill_button_container/skill_button_panel/affinity_icons/dark.png?raw=true)
Flesh | ![Image of Turn Press icons](main/ui/menu/game_menu/party_skill_container/skill_button_container/skill_button_panel/affinity_icons/flesh.png?raw=true)
Buff | ![Image of Turn Press icons](main/ui/menu/game_menu/party_skill_container/skill_button_container/skill_button_panel/affinity_icons/buff.png?raw=true)
Passive | ![Image of Turn Press icons](main/ui/menu/game_menu/party_skill_container/skill_button_container/skill_button_panel/affinity_icons/passive2.png?raw=true)
Heal | ![Image of Turn Press icons](main/ui/menu/game_menu/party_skill_container/skill_button_container/skill_button_panel/affinity_icons/heal.png?raw=true)

### Effects
Equipping an effect changes your resistances and affinities. Every effect also has its own set of learnable skills. Any time you level up, you can unlock a new skill from the effect that is currently equipped if your level is high enough. Choose carefully, as these skills are only possible to learn once.

### Recruiting
You can add more units to your party by recruiting them during battle. If you meet the requirements below, you are available to recruit them. As of version a1.0, this is calculated through your luck stat. This is subject to change in later versions.

#### Recruit Requirements
1. You don't already own the creature you are trying to recruit
2. Your level is higher than or equal to the creature's
3. Your stock isn't full (maximum of 12 creatures)

### Fusion
Fusion allows you to combine two creatures into a stronger unit while also passing skills from the ingredients to the result.

#### Fusion Requirements
1. You don't already own the creature you are trying to fuse
2. Your level is higher than or equal to the result's

### Turn Press System
Fractiwi uses the Turn Press System for combat. From the [Megami Tensei Wiki](https://megamitensei.fandom.com/wiki/Turn_Press):
> In a Turn Press Battle, the process of switching between the player's and the enemy's turn is determined by the Turn Icons consumed from individual actions. Each side is able to carry out multiple actions at a time, and when all Turn Icons are used up, the phase switches to the other side and continues until the battle has ended.

> Generally, there will be the same amount of Turn Icons as there are units on each side, and under normal circumstances, every action consumes one Turn Icon. The Turn Icon issued at the beginning of each phase is always a "whole" icon, but depending on the result of the action, such as when exploiting a weakness, scoring critical hit, passing one's turn, etc., the whole icon may turn into a "half" (blinking) icon, effectively increasing the number of actions one side can take within that phase. However, a failed result will always consume more Turn Icons.

> When the effective Turn Icons exceed the size of the team due to half-icon consumption, the action order will rewind back to the teammate who acted first and continue until all Turn Icons deplete . . . [T]he action order is dictated by the agility stats of all combatants of one side.

![Image of Turn Press icons](gameplay_images/gameplay1.png?raw=true "Turn Press icons") ![Image of Half Turn Press icons](gameplay_images/gameplay2.png?raw=true "Half/Flashing Turn Press icons")
