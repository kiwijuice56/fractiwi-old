extends ButtonContainer
class_name FullSkillButtonContainer

var creatures := []
var all_skills := []

signal skill_selected

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept", false):
		if not get_focus_owner().selected:
			emit_signal("skill_selected", get_focus_owner().skill)
	elif event.is_action_pressed("ui_accept2", false):
		emit_signal("skill_selected", "Done")
	elif event.is_action_pressed("ui_cancel", false):
		emit_signal("skill_selected", "Cancel")

func intialize_button(new_button: Control, index: int) -> void:
	new_button.set_content(all_skills[index])

func add_items() -> void:
	all_skills = []
	var all_skill_names := []
	for creature in creatures:
		for skill in creature.get_node("Skills/Active").get_children() + creature.get_node("Skills/Passive").get_children():
			if not skill.name in all_skill_names:
				all_skill_names.append(skill.name)
				all_skills.append(skill)
	button_count = len(all_skills)
	.add_items()

func set_selected(skills: Array) -> void:
	for skill in skills:
		get_node(skill.name).selected = true

func choose_skill():
	set_process_input(true)
	var skill_chosen = yield(self, "skill_selected")
	set_process_input(false)
	return skill_chosen

