extends Node
class_name Items

var current_effect := "Normal"
var effects: Array

func get_off() -> Dictionary:
	return get_node("Effects").get_node(current_effect).off_affinities

func get_def() -> Dictionary:
	return get_node("Effects").get_node(current_effect).def_affinities

func get_effect_skill_node() -> Node:
	return get_node("Effects").get_node(current_effect)

func get_effect_skill_names() -> Dictionary:
	var effect_skill_names := {}
	for effect in $Effects.get_children():
		effect_skill_names[effect.name] = {"Unlearned" : effect.get_skill_names("all")}
	return effect_skill_names

func set_effect_skills(data: Dictionary) -> void:
	for effect in $Effects.get_children():
		effect.set_skills(data[effect.name])

func save_data() -> Dictionary:
	return {"effects": effects, "effect_skills": get_effect_skill_names(), "current_effect": current_effect}

func load_data(data: Dictionary) -> void:
	effects = data["effects"]
	set_effect_skills(data["effect_skills"])
	get_viewport().world_node.player.set_effect(data["current_effect"], false)
