extends UIController
class_name InteractMenu

var current_interactable: Interactable

func input_pressed(key_name: String) -> void:
	if key_name == current_interactable.state:
		current_interactable.interacted()

func enable() -> void:
	if current_interactable:
		visible = true
		input["HotkeyContainer"].hotkeys = {current_interactable.state : "ui_accept"}
		input["HotkeyContainer"].add_items()
		input["HotkeyContainer"].enable_input()

func disable() -> void:
	visible = false
	input["HotkeyContainer"].disable_input()

func finish_interaction() -> void:
	if current_interactable:
		current_interactable.finish_interaction()
