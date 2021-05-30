extends ButtonContainer
class_name SaveFileButtonContainer

var files = []

func intialize_button(new_button, index: int) -> void:
	if files[index]:
		new_button.initialize(controller.file_saver.path + files[index], index)
	else:
		new_button.initialize("", index)

func add_items() -> void:
	for child in get_children():
		remove_child(child)
	button_count = 99
	files = controller.file_saver.get_files()
	.add_items()
