extends UIController
class_name CathedralMenu

export var music: Resource

func input_pressed(key_name: String) -> void:
	if disabled: return
	disable(true)
	match key_name:
		"Fuse":
			main_viewport.transition.transition_in()
			yield(main_viewport.transition, "in_finished")
			main_viewport.fusion.enable(true)
			main_viewport.fusion.back = self
			main_viewport.transition.transition_out()
		"Abandon Creature":
			main_viewport.transition.transition_in()
			yield(main_viewport.transition, "in_finished")
			main_viewport.fusion.enable(true)
			#main_viewport.save_file.set_up("Load")
			main_viewport.fusion.back = self
			main_viewport.transition.transition_out()
		"Leave":
			main_viewport.transition.transition_in_heavy()
			yield(main_viewport.transition, "in_finished")
			main_viewport.interact.finish_interaction()
			main_viewport.game.enable(true)
			main_viewport.world_node.play_room_music()
			main_viewport.transition.transition_out_heavy()
	disable(false)

func enable(show: bool) -> void:
	.enable(show)
	input["TextButtonContainer"].enable_input()
	input["TextButtonContainer"].grab_focus_at(0)
	main_viewport.music_player.play_audio(music)

func disable(show: bool) -> void:
	.disable(show)
	input["TextButtonContainer"].disable_input()
