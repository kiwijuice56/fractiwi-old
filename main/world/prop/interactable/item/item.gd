extends Interactable
class_name Item

export(String, "item", "effect") var type := "item"
export var item: String
export var count: int

signal accepted

func _ready() -> void:
	set_process_input(false)

func _input(event) -> void:
	if event.is_action_pressed("ui_accept", false):
		emit_signal("accepted")

func interacted() -> void:
	player.can_move = false
	get_viewport().game.can_open = false
	match type:
		"item":
			get_viewport().items.add_consumable(item, count)
		"effect":
			get_viewport().items.effects.append(item)
	var world = get_viewport().world_node
	world.memory[world.current_room][name] = true
	player.main_viewport.interact.disable(true)
	yield(get_viewport().interact.show_text("Got " + type + ": " + item + " x"+str(count) ), "completed")
	set_process_input(true)
	$AudioStreamPlayer.playing = true
	yield($AudioStreamPlayer, "finished")
	yield(self, "accepted")
	set_process_input(false)
	player.can_move = true
	get_viewport().game.can_open = true
	queue_free()

func finish_interaction() -> void:
	pass

func load_memory(room_memory: Dictionary) -> void:
	if name in room_memory:
		queue_free()
