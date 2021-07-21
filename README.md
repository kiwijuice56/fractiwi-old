# About
Fractiwi is an open-source exploration game with turn-based combat. Inspired by the Shin Megami Tensei franchise and Yume Nikki fangames.

# How to Play
The ```HOWTOPLAY.md``` file contains a brief summary of the gameplay as well as more detailed information about game mechanics.

# Created With
- [Godot Game Engine](https://godotengine.org/), using gdscript

# Contribute
All types of contributations (art, programming, music) are greatly appreciated!
Even if you have no programming experience, you can contact alfaroeric127@gmail.com to propose ideas or transfer assets to be implemented in the game.
If you are familiar with Godot, follow the instructions below for the specific content you are creating.

## Rooms
1. Create a folder with the name of your room (using snake_case) in ```res://main/world/room/```
2. Create an inherited scene of ```res://main/world/room/Room.tscn```
3. Make any changes and save the scene to your folder. Keep the name of this scene as Room.tscn. Your room is now ready to be loaded in game!

### Collision
- Ensure your props and TileMaps are set on the appropriate collision layers (visible in the Project Settings)
- No node should be on the player collision layer

### Beds
- There is no strict requirement for what or where you place any nodes, but all beds should be placed as a child of ```Props/Interactable/Terminals```
- Make sure any bed's ```Room``` variable is set to the root of your scene

### Enemies
1. Instance an enemy from ```res://main/world/enemy/```
2. Set the enemy's ```Creature``` variable to an array of creatures of your choice from ```res://main/battle/creature/```
3. Keep ```Anim Name``` to the name of the animation you want to be looping on your enemy
4. Configure any other variables with sensible values

### Music
- Compare your music files with others in-game to make sure it isn't too loud or quiet. A range of -15 to -8 db is recommended
- Reimport any music files with ```loop``` enabled
- Attach music files to the room's ```Music``` variable

## Combat

### Creatures
1. Create a folder with the name of your creature (using all lower case, using spaces instead of underscores) in ```res://main/battle/creature/```
2. Create an inherited scene of ```res://main/battle/creature/Creature.tscn```
3. Set its ```Creature Name``` variable to match the name of the folder but capitalized (eye worm -> Eye Worm)
4. Set its stats to any integer value above 0
5. If wanted, set its ```Def Offinity``` to a dictionary (String : String) with affinities as keys and a resistance as values
Affinities: ```"phys", "fire", "water", "elec", "wind", "light", "dark", "flesh"```
Resistances: ```"resist", "repel", "absorb", "null", "weak"```
6. Do the same with ```Off Affinity```, but replace the value with an integer value in the range of [180, 110] or [-110, -180] for negative boosts. The middle digit and the sign represent the actual value seen in game (ie. -180 -> -8, 140 -> 4). Keep your value in multiples of tens
7. Instance skills from ```res://main/battle/skill/``` and place them into the appropriate skill nodes of the creature
8. If this creature will learn skills at certain level ups, place them in order as children of ```UnlearnedSkills``` and configure the ```Skill Levels``` array to hold every integer level at which this creature will learn a skill
9. Attach any ai script from ```res://main/battle/ai/``` to ```AI```. The default ai script will choose skills to use at random

### AI
1. Extend ```res://main/battle/ai/ai.gd``` script and place this new script within a new folder under ```res://main/battle/ai/```
2. Overwrite the ```do_turn``` function with the logic your ai implements
```
func do_turn(same: Array, opposite: Array, controller: Creature) -> Array:
	# opposite: array of opposing party creatures
	# same: array of team party creatures
	# controller: the creature calling this function

	# return array 0: tag of current action, "Skill" or "Pass" in most cases
	# return array 1: reference to skill of creature if tag is "Skill" 
	# return array 2: an array of the targets of the skill if tag is "Skill"

	# example:
	return ["Skill",  controller.get_node("Skills/Active/Cleave"), [opposite[0]]
```
3. Attach this script to any creature's ```AI``` node

# License

Distributed under the GNU General Public License v2.0. See LICENSE.md for more information.
