extends ButtonContainer
class_name ItemButtonContainer

var items: Array

func intialize_button(new_button: Control, index: int) -> void:
	new_button.set_content(SkillsManager.get_skill(items[index]), get_viewport().items.consumables[items[index]])

func add_items() -> void:
	items = get_viewport().items.consumables.keys()
	button_count = len(items)
	.add_items()
