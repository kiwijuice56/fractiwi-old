extends Node

export (NodePath) var player

func _ready() -> void:
	player = get_node(player)
