extends UIController
class_name SaveFileMenu
# Main controller for save file menu

export (NodePath) var file_saver
export (NodePath) var desc_label

func _ready():
	desc_label = get_node(desc_label)
	file_saver = get_node(file_saver)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel", false) and not disabled: 
		main_viewport.transition.transition_in()
		disable(true)
		yield(main_viewport.transition, "in_finished")
		disable(false)
		back.enable(true)
		main_viewport.transition.transition_out()

func input_pressed(key_name: String) -> void:
	var index := get_focus_owner().get_index()
	var scroll = input["SaveFileContainer"].get_parent().scroll_vertical
	match key_name:
		"Save":
			file_saver.save_file(index)
		"Load":
			if input["SaveFileContainer"].files[index]:
				disable(true)
				file_saver.load_file(index)
				main_viewport.root.start()
				return
	input["SaveFileContainer"].add_items()
	set_up(key_name)
	input["SaveFileContainer"].grab_focus_at(index)
	input["SaveFileContainer"].get_parent().scroll_vertical = scroll

func set_up(event: String) -> void:
	input["SaveFileContainer"].add_items()
	if event == "Load":
		desc_label.text = "Load which file?"
		input["SaveFileHotkeyContainer"].hotkeys = {"Load":"ui_accept"}
	elif event == "Save":
		desc_label.text = "Save over which file?"
		input["SaveFileHotkeyContainer"].hotkeys = {"Save":"ui_accept"}
	input["SaveFileHotkeyContainer"].add_items()
	input["SaveFileContainer"].grab_focus_at(0)

func enable(show: bool) -> void:
	.enable(show)
	input["SaveFileHotkeyContainer"].enable_input()

func disable(show: bool) -> void:
	input["SaveFileHotkeyContainer"].disable_input()
	.disable(show)
