# About
Fractiwi is an exploration game with turn-based combat.

# Created With
- [Godot Game Engine](https://godotengine.org/), using gdscript

# Contribute
All types of contributations (art, programming, music) are greatly appreciated!
Even if you have no programming experience, you can contact alfaroeric127@gmail.com to propose ideas or transfer assets to be implemented in the game.
If you are familiar with Godot, follow the instructions below for specific content you are creating.

## Rooms
1. Create a folder with the name of your room (using snake_case) in ```res://main/world/room/```
2. Create an inherited scene of ```res://main/world/room/Room.tscn```
3. Make any changes and save the scene to your folder. Keep the name of this scene as Room.tscn. Your room is now ready to be loaded in game!

### Collision
- Ensure your props and TileMaps are set on the appropriate collision layers (visible in the Project Settings).

### Beds
- There is no strict requirement for what or where you place any nodes, but all beds should be placed under ```Props/Interactable/Terminals```
- Make sure any bed's ```Room``` variable is set to the root of your scene

### Enemies
1. Instance an enemy from ```res://main/world/enemy/```
2. Set the enemy's ```Creature``` variable to an array of creatures of your choice from ```res://main/battle/creature/```
3. Keep ```Anim Name``` to the name of the animation you want to be looping on your enemy
4. Configure any other variables with sensible values
