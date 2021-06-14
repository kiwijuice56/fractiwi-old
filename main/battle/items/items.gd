extends Node

var effects: Array

func save_data() -> Dictionary:
	return {"effects": effects}

func load_data(data: Dictionary) -> void:
	effects = data["effects"]
