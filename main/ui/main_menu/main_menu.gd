extends UIController
# Main controller for start screen

func _ready() -> void:
	yield(get_tree().root, "ready")
	input["MainTextButtonContainer"].enable_input()
	input["MainTextButtonContainer"].grab_focus_at(0)

func input_pressed(key_name: String) -> void:
	match key_name:
		"New Game":
			main.new_game()
		"Load Game":
			main_viewport.transition.transition_in()
			yield(main_viewport.transition, "in_finished")
			main_viewport.hide_menu("Main")
			main_viewport.show_menu("Save")
			main_viewport.transition.transition_out()
		"Settings":
			pass
