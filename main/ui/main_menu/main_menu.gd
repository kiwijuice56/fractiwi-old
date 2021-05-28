extends UIController

var main

func _ready() -> void:
	main = get_tree().get_root().get_child(0)
	yield(get_tree().root, "ready")
	input["MainTextButtonContainer"].enable_input()
	input["MainTextButtonContainer"].grab_focus_at(0)

func input_pressed(key_name: String) -> void:
	match key_name:
		"New Game":
			main.new_game()
		"Load Game":
			pass
		"Settings":
			pass
