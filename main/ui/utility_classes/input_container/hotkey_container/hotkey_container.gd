extends InputContainer
class_name HotKeyContainer
# Instances descriptive labels and creates temporary hotkey inputs 

export var hotkey_font: Resource
export var hotkey_color: Color = Color(.6,.6,.6)
export var up_down_image: StreamTexture = preload("res://main/ui/utility_classes/input_container/hotkey_container/up_down_arrows.png")
export var left_right_image: StreamTexture = preload("res://main/ui/utility_classes/input_container/hotkey_container/left_right_arrows.png")
export(Dictionary) var hotkeys

func _input(event: InputEvent) -> void:
	for key in hotkeys.keys():
		if not key in hotkeys:
			return
		if hotkeys[key] == "up_down" or hotkeys[key] == "left_right":
			continue
		if event.is_action_pressed(hotkeys[key], false):
			controller.input_pressed(key)

func add_items() -> void:
	for child in get_children():
		remove_child(child)
	for key in hotkeys.keys():
		var h_box = HBoxContainer.new()
		var name_label = Label.new()
		name_label.text = key + ": "
		
		var hotkey_label = Label.new()
		if hotkeys[key] == "up_down":
			hotkey_label = TextureRect.new()
			hotkey_label.texture = up_down_image
		elif hotkeys[key] == "left_right":
			hotkey_label = TextureRect.new()
			hotkey_label.texture = left_right_image
		else:
			hotkey_label.text =  InputMap.get_action_list(hotkeys[key])[0].as_text()
			hotkey_label.add_font_override("font", hotkey_font)
			hotkey_label.add_color_override("font_color", hotkey_color)
		add_child(h_box)
		h_box.add_child(name_label)
		h_box.add_child(hotkey_label)
