extends Node
# Root node of game
# Handles setting up the state of the game

export (NodePath) var party
export (NodePath) var main_viewport

# Creature
export var default_player: PackedScene

func _ready() -> void:
	party = get_node(party)
	main_viewport = get_node(main_viewport)

func new_game() -> void:
	main_viewport.transition.transition_in()
	yield(main_viewport.transition, "in_finished")
	### Set up starting room ###
	party.delete_all()
	party.add_member(default_player.instance())
	
	main_viewport.hide_menu("Main")
	main_viewport.get_menu("Game").update_party()
	main_viewport.show_menu("Game")
	main_viewport.transition.transition_out()
