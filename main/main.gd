extends Node
class_name Main
# Root node of game
# Handles setting up the state of the game

export (NodePath) var party
export (NodePath) var main_viewport
export (NodePath) var world

func _ready() -> void:
	party = get_node(party)
	main_viewport = get_node(main_viewport)
	world = get_node(world)
	yield(get_tree().root, "ready")
	$FileSaver.save_file(-1)
	main_viewport.main.enable(true)

func start() -> void:
	main_viewport.transition.transition_in_very_heavy()
	main_viewport.music_player.play_audio(null)
	yield(main_viewport.transition, "in_finished")
	main_viewport.main.disable(false)
	main_viewport.save_file.disable(false)
	main_viewport.terminal.disable(false)
	main_viewport.game.update_party()
	main_viewport.transition.transition_out_very_heavy()
	yield(main_viewport.transition, "out_finished")
