extends SkillsManager
class_name UnlearnedSkillManager

export(Array, int) var skill_levels: Array

func sort_skills() -> void:
	return

func skills_to_learn(creature) -> int:
	var count := 0
	while len(skill_levels) and skill_levels[0] <= creature.level:
		count += 1
		skill_levels.pop_front()
	return count

func get_skill_names(_type: String) -> Array:
	var names := []
	for skill in get_children():
		names.append(skill.name)
	return names

func delete_all_skills() -> void:
	for child in get_children():
		child.get_parent().remove_child(child)
		child.queue_free()

func set_skills(data: Dictionary) -> void:
	delete_all_skills()
	for skill in data["Unlearned"]:
		add_child(get_skill(skill))
