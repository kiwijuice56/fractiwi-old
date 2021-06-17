extends UIController
class_name InteractMenu

var current_interactable: Interactable

func input_pressed(key_name: String) -> void:
	if disabled: return
	if key_name == current_interactable.state:
		current_interactable.interacted()

func finish_interaction() -> void:
	visible = false
	if current_interactable:
		current_interactable.finish_interaction()

func enable(show: bool) -> void:
	if main_viewport.game.open: return
	.enable(show)
	if current_interactable:
		$AnimationPlayer.current_animation = "fade_in"
		input["HotkeyContainer"].hotkeys = {current_interactable.state : "ui_accept"}
		input["HotkeyContainer"].add_items()
		input["HotkeyContainer"].enable_input()
		get_viewport().interact.hide_text()

func disable(show: bool) -> void:
	.disable(show)
	if is_inside_tree() and modulate != Color(1,1,1,0): $AnimationPlayer.current_animation = "fade_out"
	input["HotkeyContainer"].disable_input()

func show_text(text: String) -> void:
	input["HotkeyContainer"].visible = false
	$PanelContainer/Label.text = text
	$PanelContainer/Label.visible = true

func hide_text() -> void:
	input["HotkeyContainer"].visible = true
	$PanelContainer/Label.visible = false
