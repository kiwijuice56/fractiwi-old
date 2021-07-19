extends Node2D
class_name Room

export (NodePath) var terminals
export (NodePath) var doors
export var music: Resource
export var backdrop: Resource
export var backdrop_dir := Vector2(.1, .1)

var current_terminal: String = "Bed" # set by terminals on entrance

func _ready() -> void:
	terminals = get_node(terminals)
	doors = get_node(doors)
