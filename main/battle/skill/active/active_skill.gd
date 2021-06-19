extends Skill
class_name ActiveSkill

export var effect_packed: PackedScene 
export(String, "hp", "mp") var cost_type := "mp"
export var cost := 0
export(String, "all", "single", "random") var target_type := "single"
export(String, "opposite", "same") var side := "opposite"
export(int, 0, 100) var accuracy := 0
signal use_complete

func use(_user: Node, _targets: Array, _anim: bool) -> void:
	emit_signal("use_complete")

func is_miss(user: Node, target: Node) -> bool:
	print( (accuracy + ((user.agil - target.agil)/2.0) + ((user.luck-target.luck)/2.0)) / 100.0)
	return rand_range(0,1) >= (accuracy + ((user.agil - target.agil)/2.0) + ((user.luck-target.luck)/2.0)) / 100.0

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

func get_def_affinity(target: Node) -> String:
	if affinity in target.get_def():
		return target.def_affinity[affinity]
	return "normal"

func get_off_affinity(user: Node) -> int:
	if affinity in user.get_off():
		return user.off_affinity[affinity]
	return 100

