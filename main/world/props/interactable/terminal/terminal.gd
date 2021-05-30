extends Interactable
class_name Terminal

func interacted() -> void:
	get_viewport().transition.transition_in()
	get_viewport().game.disable()
	get_viewport().world_node.player.can_move = false
	yield(get_viewport().transition, "in_finished")
	get_viewport().terminal.enable()
	get_viewport().interact.disable()
	get_viewport().transition.transition_out()

func finish_interaction() -> void:
	get_viewport().world_node.player.can_move = true

