extends UIController
class_name MainMenu
# Main controller for start screen

func _ready() -> void:
	yield(get_tree().root, "ready")

func input_pressed(key_name: String) -> void:
	match key_name:
		"New Game":
			main_viewport.root.new_game()
		"Load Game":
			main_viewport.transition.transition_in()
			yield(main_viewport.transition, "in_finished")
			main_viewport.save_file.enable()
			main_viewport.save_file.set_up("Load")
			main_viewport.save_file.back = self
			main_viewport.transition.transition_out()
		"Settings":
			pass

func enable():
	visible = true
	input["MainTextButtonContainer"].enable_input()
	input["MainTextButtonContainer"].grab_focus_at(0)

func disable():
	visible = false
	input["MainTextButtonContainer"].disable_input()
