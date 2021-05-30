extends UIController
class_name TerminalMenu

func input_pressed(key_name: String) -> void:
	main_viewport.transition.transition_in()
	yield(main_viewport.transition, "in_finished")
	match key_name:
		"Save":
			main_viewport.save_file.enable()
			main_viewport.save_file.set_up("Save")
			main_viewport.save_file.back = self
		"Load":
			main_viewport.save_file.enable()
			main_viewport.save_file.set_up("Load")
			main_viewport.save_file.back = self
		"Leave":
			main_viewport.terminal.disable()
			main_viewport.interact.finish_interaction()
			main_viewport.game.enable()
	main_viewport.transition.transition_out()

func enable() -> void:
	visible = true
	input["TextButtonContainer"].enable_input()
	input["TextButtonContainer"].grab_focus_at(0)

func disable() -> void:
	visible = false
	input["TextButtonContainer"].disable_input()
