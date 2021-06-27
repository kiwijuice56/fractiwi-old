extends ButtonContainer
class_name FusionCreatureButtonContainer

var creatures := []

func intialize_button(button: Control, index: int) -> void:
	button.initialize(creatures[index])

func add_items() -> void:
	button_count = len(creatures)
	.add_items()

