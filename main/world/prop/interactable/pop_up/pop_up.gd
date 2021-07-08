extends Interactable
class_name PopUp

func interacted() -> void:
	player.can_move = false
	get_viewport().game.can_open = false
	get_viewport().interact.disable(true)
	$AnimationPlayer.current_animation = "pop_up"
	yield($AnimationPlayer, "animation_finished")
	player.can_move = true
	get_viewport().game.can_open = true
	get_viewport().interact.disable(true)
