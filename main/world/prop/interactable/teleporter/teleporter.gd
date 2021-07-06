extends Interactable
class_name Teleporter

export var destination: NodePath

func interacted() -> void:
	player.can_move = false
	get_viewport().game.can_open = false
	get_viewport().interact.disable(true)
	player.teleport(get_node(destination))
