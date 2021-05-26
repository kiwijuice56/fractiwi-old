extends Control

var input := {}

func _ready():
	yield(get_tree().root, "ready")
	input["MainTextButtonContainer"].enable_input()
	input["MainTextButtonContainer"].grab_focus_at(0)
