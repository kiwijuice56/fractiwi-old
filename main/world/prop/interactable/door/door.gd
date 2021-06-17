extends Interactable
class_name Door

export(String, "up", "down", "left", "right") var face_direction: String = "up"
export var room_name: String
export var destination_name: String

func interacted() -> void:
	player.can_move = false
	get_viewport().game.can_open = false
	get_viewport().interact.disable(true)
	get_viewport().transition.transition_in()
	yield(get_viewport().transition, "in_finished")
	player.face_direction(face_direction)
	get_viewport().world_node.add_room(room_name, "door", destination_name)
	

func finish_interaction() -> void:
	pass
