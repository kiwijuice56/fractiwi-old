extends ButtonContainer
class_name TextButtonContainer
# Instances basic buttons with text

export (Array, String) var button_names: Array

func intialize_button(new_button, index: int) -> void:
	new_button.text = button_names[index]
	new_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	new_button.connect("button_down", controller, "input_pressed", [button_names[index]])
	new_button.set_h_size_flags(SIZE_EXPAND_FILL)
	new_button.set_v_size_flags(SIZE_EXPAND_FILL)

func add_items() -> void:
	button_count = len(button_names)
	.add_items()
