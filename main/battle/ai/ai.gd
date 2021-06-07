extends Node
class_name AI
# Controls logic for combat action by creatures

var yielded := false

# Returns array with action for creature to take
func do_turn(_same: Node, opposite: Node, _controller: Creature) -> Array:
	return ["Skill", get_parent().get_node("Skills/Active/Slash"), [opposite.get_child(0)]]
