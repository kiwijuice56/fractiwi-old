extends TextureRect
class_name PressTurn

var seen := false

func set_visible(is_visible: bool) -> void:
	if is_visible and not seen:
		$VisibilityPlayer.current_animation = "show"
		seen = true
	if not is_visible and seen:
		$VisibilityPlayer.current_animation = "hide"
		seen = false

func set_half(is_half: bool) -> void:
	if is_half and $HalfPlayer.current_animation != "half":
		$HalfPlayer.current_animation = "become_half"
		yield($HalfPlayer, "animation_finished")
		$HalfPlayer.current_animation = "half"
	else:
		$HalfPlayer.current_animation = ""
		$HalfTurn.modulate = Color(0,0,0,0)
