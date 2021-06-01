extends Node
class_name Main
# Root node of game
# Handles setting up the state of the game

export (NodePath) var party
export (NodePath) var main_viewport
export (NodePath) var world

# Creature
export var default_player: PackedScene
export var default_room: String

func _ready() -> void:
	party = get_node(party)
	main_viewport = get_node(main_viewport)
	world = get_node(world)
	
	yield(get_tree().root, "ready")
	main_viewport.main.enable()

func start() -> void:
	main_viewport.transition.transition_in_heavy()
	yield(main_viewport.transition, "in_finished")
	world.player.can_move = true
	main_viewport.main.disable()
	main_viewport.save_file.disable()
	main_viewport.terminal.disable()
	main_viewport.game.update_party()
	main_viewport.game.enable()
	main_viewport.transition.transition_out_heavy()
