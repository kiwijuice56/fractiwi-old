extends Interactable
class_name Terminal

export(NodePath) var room 

func _ready() -> void:
	room = get_node(room)

func interacted() -> void:
	room.current_terminal = name
	get_viewport().transition.transition_in_heavy()
	get_viewport().game.disable(false)
	get_viewport().world_node.player.can_move = false
	yield(get_viewport().transition, "in_finished")
	get_viewport().terminal.enable(true)
	get_viewport().interact.disable(false)
	get_viewport().transition.transition_out_heavy()

func finish_interaction() -> void:
	get_viewport().world_node.player.can_move = true

