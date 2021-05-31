extends Node

export (NodePath) var player
export var room_path: String
var current_room: String = "block"
var temp_data: Dictionary

func _ready() -> void:
	player = get_node(player)

func add_room(room_name: String) -> void:
	if has_node("Room"):
		remove_child(get_node("Room"))
	current_room = room_name
	var scene = load(room_path + current_room + "/Room.tscn")
	var room = scene.instance()
	add_child(room)

func save_data() -> Dictionary:
	return {"location" : current_room, "memory": temp_data}

func load_data(data: Dictionary) -> void:
	add_room(data["location"])
