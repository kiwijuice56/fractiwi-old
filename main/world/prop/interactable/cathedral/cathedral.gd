extends Interactable
class_name Cathedral

func interacted() -> void:
	.interacted()
	get_viewport().transition.transition_in_heavy()
	get_viewport().game.disable(false)
	get_viewport().world_node.player.can_move = false
	get_viewport().world_node.pause()
	yield(get_viewport().transition, "in_finished")
	get_viewport().cathedral.enable(true)
	get_viewport().interact.disable(false)
	get_viewport().transition.transition_out_heavy()

func finish_interaction() -> void:
	get_viewport().world_node.unpause()
	get_viewport().world_node.player.can_move = true
	get_viewport().world_node.player.set_physics_process(true)
