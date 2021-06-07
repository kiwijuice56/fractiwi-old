extends Skill
class_name ActiveSkill

export var effect_packed: PackedScene 
export(String, "phys", "fire", "ice", "elec", "wind", "light", "death", "mind", "flesh") var affinity := "phys"
export(String, "all", "single", "random") var target_type := "single"
export(String, "opposite", "same") var side := "opposite"
export(int, 0, 100) var accuracy := 0

func use(user: Creature, targets: Array, anim: bool) -> void:
	pass

func is_miss(user: Creature, target: Creature) -> bool:
	return rand_range(0,1) >= accuracy/100.0

func turn_logic(def: String, is_miss: bool, is_crit: bool) -> int:
	if is_miss:
		return -1
	match def:
		"weak":
			return 2
		"repel":
			return -2
		"null":
			return -1
		"absorb":
			return -1
	if is_crit:
		return 2
	return 0

func get_def_affinity(target: Creature) -> String:
	if affinity in target.def_affinity:
		return target.def_affinity[affinity]
	return "normal"

func get_off_affinity(user: Creature) -> int:
	if affinity in user.off_affinity:
		return user.off_affinity[affinity]
	return 100

