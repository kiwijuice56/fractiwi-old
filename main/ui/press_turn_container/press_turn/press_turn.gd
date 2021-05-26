extends TextureRect
class_name PressTurn

func set_half(is_half: bool) -> void:
	if is_half:
		$AnimationPlayer.current_animation = "become_half"
		yield($AnimationPlayer, "animation_finished")
		$AnimationPlayer.current_animation = "half"
	else:
		$AnimationPlayer.current_animation = "full"
