extends Node
class_name AI
# Controls logic for combat action by creatures

export var player_ai: Script
var yielded := false

func switch_script() -> void:
	set_script(player_ai)

# Returns array with action for creature to take
func do_turn(_same: Array, opposite: Array, _controller: Creature) -> Array:
	return ["Skill", get_parent().get_node("Skills/Active/Slash"), [opposite[0]]]
