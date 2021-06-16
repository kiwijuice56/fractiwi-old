extends Interactable
class_name Bed

func interacted() -> void:
	if state == "Enter bed":
		player.can_move = false
		get_viewport().game.can_open = false
		get_viewport().interact.disable(true)
		yield(player.tween_sprite(global_position, 0.3), "completed")
		$Sprite.frame = 0
		player.visible = false
		state = "Exit bed"
		body_entered(player)
	else:
		finish_interaction()

func finish_interaction() -> void:
	player.visible = true
	$Sprite.frame = 1
	state = "Enter bed"
	get_viewport().interact.disable(true)
	yield(player.tween_sprite(player.global_position, 0.3), "completed")
	player.can_move = true
	body_entered(player)
	get_viewport().game.can_open = true
