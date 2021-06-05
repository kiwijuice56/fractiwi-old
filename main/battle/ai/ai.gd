extends Node
class_name AI
# Controls logic for combat action by creatures

var yielded := false

# Returns array with action for creature to take
func do_turn(_same: Node, _opposite: Node, _controller: Creature) -> Array:
	return ["Pass", null, []]
