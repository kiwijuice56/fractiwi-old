extends SoundPlayer

export(NodePath) var player

func _ready() -> void:
	player = get_node(player)

func play_sound(_sound: String) -> void:
	if get_node(player.surface).playing:
		return
	get_node(player.surface).playing = true
