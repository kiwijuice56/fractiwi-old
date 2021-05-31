extends UIController
class_name InteractMenu

var current_interactable: Interactable

func input_pressed(key_name: String) -> void:
	if key_name == current_interactable.state:
		current_interactable.interacted()

func finish_interaction() -> void:
	visible = false
	if current_interactable:
		current_interactable.finish_interaction()

func enable() -> void:
	disabled = false
	visible = true
	if current_interactable:
		$AnimationPlayer.current_animation = "fade_in"
		input["HotkeyContainer"].hotkeys = {current_interactable.state : "ui_accept"}
		input["HotkeyContainer"].add_items()
		input["HotkeyContainer"].enable_input()

func disable() -> void:
	disabled = true
	$AnimationPlayer.current_animation = "fade_out"
	input["HotkeyContainer"].disable_input()
