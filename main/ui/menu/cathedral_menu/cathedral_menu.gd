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
			main_viewport.fusion.ingredient1 = null
			main_viewport.fusion.ingredient2 = null
			main_viewport.fusion.update_ingredients()
			main_viewport.fusion.update_results()
			main_viewport.fusion.results = []
			main_viewport.fusion.set_up("fuse")
			main_viewport.fusion.enable(true)
			main_viewport.fusion.back = self
			main_viewport.transition.transition_out()
			disable(false)
		"Banish Creature":
			main_viewport.transition.transition_in()
			yield(main_viewport.transition, "in_finished")
			main_viewport.fusion.set_up("banish")
			main_viewport.fusion.enable(true)
			main_viewport.fusion.back = self
			main_viewport.transition.transition_out()
			disable(false)
		"Leave":
			main_viewport.transition.transition_in_heavy()
			yield(main_viewport.transition, "in_finished")
			main_viewport.world_node.play_room_music()
			main_viewport.transition.transition_out_heavy()
			disable(false)
			yield(main_viewport.transition, "out_finished")
			main_viewport.game.enable(true)
			main_viewport.interact.finish_interaction()

func enable(show: bool) -> void:
	.enable(show)
	input["TextButtonContainer"].enable_input()
	input["TextButtonContainer"].grab_focus_at(0)
	main_viewport.music_player.play_audio(music)

func disable(show: bool) -> void:
	.disable(show)
	input["TextButtonContainer"].disable_input()
