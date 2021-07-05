extends ButtonContainer
class_name PartyButtonContainer
# Instances CreatureButtonPanels connected to party data

export var empty_button_scene: PackedScene
export var full_party: bool
export var empty_buttons := false

var creatures = []

func intialize_button(new_button, index: int) -> void:
	new_button.creature = creatures[index]
	new_button.update_content()

func add_items() -> void:
	for child in get_children():
		if child.has_node("AnimationPlayer"):
			child.get_node("AnimationPlayer").stop()
		remove_child(child)
		child.queue_free()
	var active_creatures =  controller.party.get_node("Active").get_children()
	var inactive_creatures = controller.party.get_node("Inactive").get_children() 
	creatures = active_creatures+inactive_creatures if full_party else active_creatures
	button_count = len(creatures)
	.add_items()
	if empty_buttons:
		for _i in range(button_count, 4):
			add_child(empty_button_scene.instance())
