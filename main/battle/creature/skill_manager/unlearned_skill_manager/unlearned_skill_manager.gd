extends SkillsManager
class_name UnlearnedSkillManager

export(Array, int) var skill_levels: Array

func sort_skills() -> void:
	return

func skills_to_learn() -> int:
	var count := 0
	while len(skill_levels) and skill_levels[0] <= get_parent().level:
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
	var dir = Directory.new()
	for path in skill_paths:
		dir.open(path)
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if file_name.capitalize() in data["Unlearned"]:
				add_child(load(path+file_name+"/"+file_name.capitalize() + ".tscn").instance())
			file_name = dir.get_next()
