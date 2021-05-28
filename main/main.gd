extends Node
class_name Main

export (NodePath) var main_menu
export (NodePath) var game_menu
export (NodePath) var party
export (NodePath) var main_viewport
export (NodePath) var transition

export var default_player: PackedScene

func _ready() -> void:
	main_menu = get_node(main_menu)
	game_menu = get_node(game_menu)
	party = get_node(party)
	main_viewport = get_node(main_viewport)
	transition = get_node(transition)

# Set up state for new game
func new_game() -> void:
	transition.transition_in()
	yield(transition, "in_finished")
	### Set up starting room ###
	party.delete_all()
	party.add_child(default_player.instance())
	main_menu.visible = false
	game_menu.can_open = true
	transition.transition_out()
