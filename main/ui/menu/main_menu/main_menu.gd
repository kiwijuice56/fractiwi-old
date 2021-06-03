extends UIController
class_name MainMenu
# Main controller for start screen

export var music: Resource

func _ready() -> void:
	yield(get_tree().root, "ready")

func input_pressed(key_name: String) -> void:
	if disabled: return
	disable(true)
	match key_name:
		"New Game":
			main_viewport.save_file.file_saver.load_file(-1)
			main_viewport.root.start()
		"Load Game":
			main_viewport.transition.transition_in()
			yield(main_viewport.transition, "in_finished")
			main_viewport.save_file.enable(true)
			main_viewport.save_file.set_up("Load")
			main_viewport.save_file.back = self
			main_viewport.transition.transition_out()
		"Settings":
			pass

func enable(show: bool) -> void:
	.enable(show)
	input["MainTextButtonContainer"].enable_input()
	input["MainTextButtonContainer"].grab_focus_at(0)

func disable(show: bool) -> void:
	.disable(show)
	input["MainTextButtonContainer"].disable_input()
