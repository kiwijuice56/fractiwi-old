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
		yield(main_viewport.transition, "in_finished")
		main_viewport.save_file.disable()
		back.enable()
		main_viewport.transition.transition_out()

func set_up(event: String) -> void:
	if event == "Load":
		desc_label.text = "Load which file?"
	elif event == "Save":
		desc_label.text = "Save over which file?"
	input["SaveFileContainer"].grab_focus_at(0)
