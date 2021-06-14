extends ButtonContainer
class_name EffectButtonContainer


func intialize_button(new_button: Control, index: int) -> void:
	new_button.initialize(get_viewport().items.effects[index])

func add_items() -> void: # do nothing!
	button_count = len(get_viewport().items.effects)
	.add_items()
