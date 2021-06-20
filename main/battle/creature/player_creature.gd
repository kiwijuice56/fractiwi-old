extends Creature
class_name PlayerCreature


func get_def() -> Dictionary:
	return get_viewport().items.get_def()

func get_off() -> Dictionary:
	return get_viewport().items.get_off()

func set_expe_to_level() -> void:
	expe_to_level = 30*level

func get_node(node_name):
	if node_name == "UnlearnedSkills":
		return get_viewport().items.get_effect_skill_node()
	else:
		return .get_node(node_name)
