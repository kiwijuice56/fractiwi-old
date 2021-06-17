extends Node2D
class_name Room

export (NodePath) var terminals
export (NodePath) var doors
export var music: Resource
export var backdrop: Resource

var current_terminal: String # set by terminals on entrance

func _ready() -> void:
	terminals = get_node(terminals)
	doors = get_node(doors)

func load_memory(memory: Dictionary) -> void:
	for child in get_tree().get_nodes_in_group("Memory"):
		child.load_memory(memory)
