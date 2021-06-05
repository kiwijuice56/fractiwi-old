extends AI
class_name PlayerAI
# Decision making controlled by UI input from player

func do_turn(_same: Node, _opposite: Node, _controller: Creature) -> Array:
	yielded = true
	get_viewport().game.battle_input(get_parent())
	var ui_info: Array = yield(get_viewport().game, "battle_action_chosen")
	yielded = false
	return ui_info
