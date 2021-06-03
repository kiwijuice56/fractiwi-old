extends Node
class_name AI
# Controls logic for combat action by creatures

var yielded := false

# Returns string with action for creature to take
func do_turn(same: Node, opposite: Node, controller: Creature) -> String:
	return "pass"
