extends ButtonContainer
class_name SkillButtonContainer

export var active_only := false
var creature: Creature
var active_len := 0
var inactive_len := 0

func intialize_button(new_button: Control, index: int) -> void:
	if index >= active_len:
		new_button.set_content(creature.get_node("Skills/Passive").get_child(active_len-index))
	new_button.set_content(creature.get_node("Skills/Active").get_child(index))

func add_items() -> void:
	if not creature: return
	active_len = len(creature.get_node("Skills").get_skill_names("Active"))
	inactive_len = len(creature.get_node("Skills").get_skill_names("Passive"))
	if active_only:
		button_count = active_len
	else:
		button_count = active_len + inactive_len
	.add_items()