extends Node
# Contains all 3d elements of the environment

export (NodePath) var player
export (NodePath) var backdrop
export var room_path: String
var current_room: String = "block"
var memory: Dictionary
var current_terminal: String # set by terminal on menu_open
var current_enemy: Enemy

func _ready() -> void:
	player = get_node(player)
	backdrop = get_node(backdrop)
	get_viewport().connect("battle_start", self, "battle_started")
	get_viewport().connect("battle_end", self, "battle_ended")

func battle_started(_creatures: Array) -> void:
	player.can_move = false
	backdrop.visible = true
	backdrop.texture = $Room.backdrop

func battle_ended(did_run: bool) -> void:
	player.can_move = true
	backdrop.visible = false
	if not did_run:
		current_enemy.call_deferred("queue_free")
	else:
		player.global_position = current_enemy.get_node("Spawn").global_position

func add_room(room_name: String, destination_type: String, destination_name: String) -> void:
	if has_node("Room"):
		remove_child(get_node("Room"))
	current_room = room_name
	var scene = load(room_path + current_room + "/Room.tscn")
	var room = scene.instance()
	add_child(room)
	get_node("Room").load_memory(memory)
	match destination_type:
		"terminal":
			$Player.global_position = $Room.terminals.get_node(destination_name+"/Spawn").global_position
		"door":
			$Player.global_position = $Room.doors.get_node(destination_name+"/Spawn").global_position
			get_viewport().transition.transition_out()
			yield(get_viewport().transition, "out_finished")
			player.can_move = true
			get_viewport().game.can_open = true
	play_room_music()

func play_room_music() -> void:
	get_viewport().music_player.play_audio($Room.music)

func save_data() -> Dictionary:
	return {"location" : current_room, "terminal": $Room.current_terminal, "memory": memory}

func load_data(data: Dictionary) -> void:
	memory = data["memory"]
	if data["terminal"] == "":
		add_room(data["location"], "door", "Start")
	else:
		add_room(data["location"], "terminal", data["terminal"])
