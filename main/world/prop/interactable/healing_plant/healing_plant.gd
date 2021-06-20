extends Interactable

func interacted() -> void:
	player.can_move = false
	get_viewport().game.can_open = false
	get_viewport().interact.disable(true)
	get_viewport().transition.transition_in_heavy()
	yield(get_viewport().transition, "in_finished")
	for node in get_viewport().party.get_node("Active").get_children():
		node.heal_points()
		node.status = "ok"
		node.panel.update_content()
	for node in get_viewport().party.get_node("Inactive").get_children():
		node.status = "ok"
		node.heal_points()
		node.panel.update_content()
	get_viewport().transition.transition_out_heavy()
	yield(get_viewport().transition, "out_finished")
	get_viewport().interact.enable(true)
	player.can_move = true
	get_viewport().game.can_open = true
