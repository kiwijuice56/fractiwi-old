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

signal updated

# Set by skills targeted at this creature to use in appropriate time of animation
var targeted_skill_data: Array

# Returns press turns used
func do_turn(same: Node, opposite: Node) -> int:
	var action = $AI.do_turn(same, opposite, self)
	if $AI.yielded: # if player, ai must be yielded for
		action = yield(action, "completed")
	else: # if enemy, flash self to indicate turn
		$AnimationPlayer.current_animation = "my_turn"
		yield($AnimationPlayer, "animation_finished")
	var tag: String = action[0]
	var object: Node = action[1]
	var targets: Array = action[2]
	if tag == "Summon" or tag == "Return" or tag == "Pass":
		get_viewport().game.label_container.show_text(tag)
		yield(get_viewport().game.label_container, "complete")
		return 1
	if tag == "Skill":
		get_viewport().game.label_container.show_text(object.name)
		return yield(object.use(self, targets, true), "completed")
	return 0

func target_skill_effect() -> void:
	if visible: $AnimationPlayer.current_animation = "hurt_normal"
	targeted_skill_data = []

func update() -> void:
	emit_signal("updated")

# Save data / stats function

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
