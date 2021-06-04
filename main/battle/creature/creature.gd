extends Sprite
class_name Creature
# Contains data for a creature and functions to edit them

export(String, "Demon", "Human", "Inanimate", "Beast") var race: String = "Human"
export var level: int setget set_level
export var hp_growth: int
export var mp_growth: int
export var stre: int
export var magi: int
export var vita: int
export var luck: int
export var agil: int

var hp: int = 3
var max_hp: int = 10
var mp: int
var max_mp: int

# Returns press turns used
func do_turn(same: Node, opposite: Node) -> int:
	var action = $AI.do_turn(same, opposite, self)
	if $AI.yielded:
		yield(action, "completed")
	yield()
	return 0

func to_dict() -> Dictionary:
	var skills = {"Passive": $Skills.get_skill_names("Passive"),
				  "Active": $Skills.get_skill_names("Active")}
	var stats = {"level": level, "stre": stre, "magi": magi, "vita": vita,
				 "luck": luck, "agil": agil, "hp": hp, "mp": mp}
	return {"skills": skills, "stats": stats}

func set_stats(_data: Dictionary) -> void:
	pass

func set_level(new_level) -> void:
	level = new_level
	max_hp = hp_growth * level
	max_mp = mp_growth * level
