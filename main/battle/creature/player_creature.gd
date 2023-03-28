extends Creature
class_name PlayerCreature

func _ready() -> void:
	connect("hp_ratio_updated", self, "update_backdrop")

func update_backdrop(hurt_ratio: float) -> void:
	get_tree().get_root().get_node("Main/ViewportContainer/MainViewport/World/CanvasLayer/Backdrop").get_material().set_shader_param("hurt", hurt_ratio)

func get_def(get_extended: bool) -> Dictionary:
	var effect_def_affinity =  get_viewport().items.get_def()
	if get_extended:
		var combined_affinity := {}
		for key in effect_def_affinity.keys():
			combined_affinity[key] = effect_def_affinity[key]
		for key in extend_def_affinity.keys():
			combined_affinity[key] = extend_def_affinity[key]
		return combined_affinity
	return effect_def_affinity

func get_off() -> Dictionary:
	return get_viewport().items.get_off()

func set_expe_to_level() -> void:
	expe_to_level = 30*level

func get_node(node_name):
	if node_name == "UnlearnedSkills":
		return get_viewport().items.get_effect_skill_node()
	else:
		return .get_node(node_name)
