extends InputContainer
class_name ButtonContainer
# Abstract class for large sets of buttons that connect to UI controller 

export var button_scene: PackedScene
var button_count: int
export(String, "horizontal", "vertical") var neighbor_type: String = "horizontal"

func intialize_button(_new_button: Control, _index: int) -> void:
	pass

func add_items() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	for i in range(button_count):
		var new_button = Button.new() if not button_scene else button_scene.instance()
		add_child(new_button)
		intialize_button(new_button, i)
	for i in range(button_count):
		match neighbor_type:
			"horizontal":
				get_child(i).set_focus_neighbour(MARGIN_BOTTOM, get_child(i).get_path())
				get_child(i).set_focus_neighbour(MARGIN_TOP, get_child(i).get_path())
				if i == 0:
					get_child(i).set_focus_neighbour(MARGIN_LEFT, get_child(get_child_count()-1).get_path())
				else:
					get_child(i).set_focus_neighbour(MARGIN_LEFT, get_child(i-1).get_path())
				if i == get_child_count()-1:
					get_child(i).set_focus_neighbour(MARGIN_RIGHT, get_child(0).get_path())
				else:
					get_child(i).set_focus_neighbour(MARGIN_RIGHT, get_child(i+1).get_path())
			"vertical":
				get_child(i).set_focus_neighbour(MARGIN_LEFT, get_child(i).get_path())
				get_child(i).set_focus_neighbour(MARGIN_RIGHT, get_child(i).get_path())
				if i == 0:
					get_child(i).set_focus_neighbour(MARGIN_TOP, get_child(get_child_count()-1).get_path())
				else:
					get_child(i).set_focus_neighbour(MARGIN_TOP, get_child(i-1).get_path())
				if i == get_child_count()-1:
					get_child(i).set_focus_neighbour(MARGIN_BOTTOM, get_child(0).get_path())
				else:
					get_child(i).set_focus_neighbour(MARGIN_BOTTOM, get_child(i+1).get_path())

func disable_input() -> void:
	.disable_input()
	for button in get_children():
		button.disabled = true
func enable_input() -> void:
	.enable_input()
	for button in get_children():
		button.disabled = false

func grab_focus_at(index: int) -> void:
	if index >= get_child_count():
		if get_focus_owner():
			get_focus_owner().release_focus()
		return
	get_child(index).grab_focus()
