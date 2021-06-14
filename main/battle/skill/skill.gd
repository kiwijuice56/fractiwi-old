extends Node
class_name Skill

export(String, "phys", "fire", "water", "elec", "wind", "light", "dark", "flesh", "buff", "heal", "passive") var affinity := "phys"
export var description: String

func get_text() -> String:
	return description
