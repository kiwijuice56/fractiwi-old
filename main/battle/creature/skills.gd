extends Node

func get_skill_names(type: String) -> Array:
	var names := []
	for skill in get_node(type).get_children():
		names.append(skill.name)
	return names

func set_skills(data: Dictionary) -> void:
	pass
