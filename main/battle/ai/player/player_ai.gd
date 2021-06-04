extends AI
class_name PlayerAI
# Decision making controlled by UI input from player

func do_turn(same: Node, opposite: Node, controller: Creature) -> String:
	yielded = true
	get_viewport().game.battle_input(get_parent())
	var ui_info: Array = yield(get_viewport().game, "battle_action_chosen")
	yielded = false
	return ""
