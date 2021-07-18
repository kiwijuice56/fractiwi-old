extends ButtonContainer
class_name SkillButtonContainer

export var active_only := false
var creature: Creature
var active_len := 0
var inactive_len := 0

func disable_overworld() -> void:
	for child in get_children():
		if child.skill.affinity != "heal":
			child.disabled = true
		if child.skill is ActiveSkill and child.skill.side == "opposite":
			child.disabled = true
	disable_battle()

func disable_battle() -> void:
	for child in get_children():
		if child.skill is PassiveSkill:
				child.disabled = true

func intialize_button(new_button: Control, index: int) -> void:
	if index >= active_len:
		print(index, active_len)
		for s in creature.get_node("Skills/Passive").get_children():
			print(s.name)
		new_button.set_content(creature.get_node("Skills/Passive").get_child(index-active_len))
	else:
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
