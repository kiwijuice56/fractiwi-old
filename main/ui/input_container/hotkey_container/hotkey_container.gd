extends InputContainer
class_name HotKeyContainer
# Instances descrpitive labels and creates temporary hotkey inputs 

export var hotkey_font: Resource
export var hotkey_color: Color = Color(.6,.6,.6)
export(Dictionary) var hotkeys

func _input(_event: InputEvent) -> void:
	for key in hotkeys.keys():
		if Input.is_action_just_pressed(hotkeys[key]):
			controller.input_pressed(key)

func add_items() -> void:
	for child in get_children():
		remove_child(child)
	for key in hotkeys.keys():
		var h_box = HBoxContainer.new()
		var name_label = Label.new()
		var hotkey_label = Label.new()
		name_label.text = key + ": "
		hotkey_label.text =  InputMap.get_action_list(hotkeys[key])[0].as_text()
		hotkey_label.add_font_override("font", hotkey_font)
		hotkey_label.add_color_override("font_color", hotkey_color)
		add_child(h_box)
		h_box.add_child(name_label)
		h_box.add_child(hotkey_label)
