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
	if $AI.yielded: # if player, wait until taken input
		action = yield(action, "completed")
	else: # if enemy, flash self to indicate turn
		$AnimationPlayer.current_animation = "my_turn"
		yield($AnimationPlayer, "animation_finished")
	var tag: String = action[0]
	if tag == "Summon" or tag == "Return" or tag == "Pass":
		get_viewport().game.label_container.show_text(tag)
		yield(get_viewport().game.label_container, "complete")
		return 1
	return 0

func use_skill() -> void:
	pass

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
