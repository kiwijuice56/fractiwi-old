extends Node
class_name SkillsManager


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
	for skill_name in data["Active"]:
		$Active.add_child(get_skill(skill_name))
	for skill_name in data["Passive"]:
		$Passive.add_child(get_skill(skill_name))
	sort_skills()

static func get_skill(skill_name: String) -> Skill:
	var skill_paths =  ["res://main/battle/skill/active/point/",
						"res://main/battle/skill/active/status/buff/",
						"res://main/battle/skill/active/status/condition/",
						"res://main/battle/skill/passive/affinity/",
						"res://main/battle/skill/passive/stat/"]
	var dir = Directory.new()
	for path in skill_paths:
		dir.open(path)
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if file_name.capitalize() == skill_name:
				return load(path+file_name+"/"+file_name.capitalize() + ".tscn").instance()
			file_name = dir.get_next()
	return null
