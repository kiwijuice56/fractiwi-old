extends Node

export (NodePath) var player
export var room_path: String
var current_room: String = "block"
var temp_data: Dictionary
var current_terminal: String # set by terminal on menu_open

func _ready() -> void:
	player = get_node(player)
	get_viewport().connect("battle_start", self, "battle_started")

func battle_started(_creatures: Array) -> void:
	player.can_move = false

func add_room(room_name: String) -> void:
	if has_node("Room"):
		remove_child(get_node("Room"))
	current_room = room_name
	var scene = load(room_path + current_room + "/Room.tscn")
	var room = scene.instance()
	add_child(room)
	play_room_music()

func play_room_music() -> void:
	get_viewport().music_player.play_audio($Room.music)

func save_data() -> Dictionary:
	return {"location" : current_room, "terminal": $Room.current_terminal, "memory": temp_data}

func load_data(data: Dictionary) -> void:
	add_room(data["location"])
	$Player.translation = $Room.terminals.get_node(data["terminal"]).translation
