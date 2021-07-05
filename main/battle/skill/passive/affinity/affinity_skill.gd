extends PassiveSkill
class_name AffinitySkill

export(String, "phys", "fire", "water", "elec", "wind", "light", "dark", "flesh", "buff", "heal", "passive") var type_affinity := "phys"
export (String, "null", "resist", "absorb", "repel") var new_affinity := "null"

func modify_creature(creature) -> void:
	creature.extend_def_affinity[type_affinity] = new_affinity

func unmodify_creature(creature) -> void:
	creature.extend_def_affinity.erase(type_affinity)
