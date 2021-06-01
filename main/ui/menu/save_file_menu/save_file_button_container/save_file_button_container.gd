extends ButtonContainer
class_name SaveFileButtonContainer

var files = []

func intialize_button(new_button, index: int) -> void:
	if files[index] != null:
		new_button.initialize(files[index], index)
	else:
		new_button.initialize(null, index)

func add_items() -> void:
	for child in get_children():
		remove_child(child)
	button_count = 99
	files = []
	files = controller.file_saver.get_files()
	.add_items()
	disable_empty()

func disable_empty() -> void:
	for i in range(len(files)):
		if not files[i]:
			get_child(i).disabled = true
		else:
			get_child(i).disabled = false
