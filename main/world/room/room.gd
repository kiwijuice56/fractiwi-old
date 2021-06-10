extends Node2D
class_name Room

export (NodePath) var terminals
export var music: Resource
export var backdrop: Resource

var current_terminal: String # set by terminals on entrance

func _ready() -> void:
	terminals = get_node(terminals)
