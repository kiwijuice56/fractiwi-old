extends ButtonContainer
class_name PartyButtonContainer
# Instances CreatureButtonPanels connected to party data

export var full_party: bool

var creatures = []

func intialize_button(new_button, index: int) -> void:
	new_button.creature = creatures[index]
	new_button.update_content()

func add_items() -> void:
	for child in get_children():
		remove_child(child)
	var active_creatures =  controller.party.get_node("Active").get_children()
	var inactive_creatures = controller.party.get_node("Inactive").get_children() 
	creatures = active_creatures+inactive_creatures if full_party else active_creatures
	button_count = len(creatures)
	.add_items()
