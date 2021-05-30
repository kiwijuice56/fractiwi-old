extends ButtonContainer
class_name SaveFileButtonContainer

var files = []

func intialize_button(new_button, index: int) -> void:
	pass

func add_items() -> void:
	for child in get_children():
		remove_child(child)
	button_count = 3#len(creatures)
	.add_items()
