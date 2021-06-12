extends Node

export(Array, String) var skill_paths: Array

func _ready() -> void:
	sort_skills()

func alph_sort(a: Skill, b: Skill) -> bool:
	return a.name < b.name

func sort_skills() -> void:
	for node in [$Active, $Passive]:
		var skills = node.get_children()
		for skill in skills:
			node.remove_child(skill)
		skills.sort_custom(self, "alph_sort")
		for skill in skills:
			node.add_child(skill)

func get_skill_names(type: String) -> Array:
	var names := []
	for skill in get_node(type).get_children():
		names.append(skill.name)
	return names

func delete_all_skills() -> void:
	for child in $Passive.get_children() + $Active.get_children():
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
			if file_name.capitalize() in data["Active"]:
				$Active.add_child(load(path+file_name+"/"+file_name.capitalize() + ".tscn").instance())
			elif file_name.capitalize() in data["Passive"]:
				$Passive.add_child(load(path+file_name+"/"+file_name.capitalize() + ".tscn").instance())
			file_name = dir.get_next()
	sort_skills()
