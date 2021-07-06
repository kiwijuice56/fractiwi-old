extends Node
class_name AI
# Controls logic for combat action by creatures

export var player_ai: Script
var yielded := false

func switch_script() -> void:
	set_script(player_ai)

# Returns array with action for creature to take
func do_turn(same: Array, opposite: Array, _controller: Creature) -> Array:
	randomize()
	var skill_idx := randi() % (get_parent().get_node("Skills/Active").get_child_count())
	var skill = get_parent().get_node("Skills/Active").get_child(skill_idx)
	var creatures := []
	if skill.target_type == "all":
		if skill.side == "opposite":
			creatures = opposite
		else:
			creatures = same
	else:
		if skill.side == "opposite":
			creatures = [opposite[randi() % (len(opposite))]]
		else:
			creatures = [same[randi() % (len(same))]]
	return ["Skill",  skill, creatures]
