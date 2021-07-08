extends AI
class_name MotherAI

var anger := 0

func do_turn(same: Array, opposite: Array, _controller: Creature) -> Array:
	randomize()
	var skill
	if anger%2:
		skill = get_parent().get_node("Skills/Active").get_child(0)
	else:
		skill = get_parent().get_node("Skills/Active").get_child(1)
	var creatures := []
	if skill.target_type == "all":
		if skill.side == "opposite":
			creatures = opposite
		else:
			creatures = same
	else:
		if skill.side == "opposite":
			var last = opposite[0].get_parent().get_child(len(opposite)-1)
			creatures = [last]
		else:
			creatures = [get_parent()]
	anger += 1
	return ["Skill",  skill, creatures]
