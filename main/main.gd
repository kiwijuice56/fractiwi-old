extends Node
class_name Main
# Root node of game
# Handles setting up the state of the game

export (NodePath) var party
export (NodePath) var main_viewport
export (NodePath) var world

# Creature
export var default_player: PackedScene
export var default_room: PackedScene

func _ready() -> void:
	party = get_node(party)
	main_viewport = get_node(main_viewport)
	world = get_node(world)
	yield(get_tree().root, "ready")
	main_viewport.main.enable()

func new_game() -> void:
	main_viewport.transition.transition_in()
	yield(main_viewport.transition, "in_finished")
	world.add_child(default_room.instance())
	party.delete_all()
	party.add_member(default_player.instance())
	world.player.can_move = true
	main_viewport.main.disable()
	main_viewport.game.update_party()
	main_viewport.game.enable()
	main_viewport.transition.transition_out()
