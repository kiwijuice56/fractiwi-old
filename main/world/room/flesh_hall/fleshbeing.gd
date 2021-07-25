extends Interactable

var visited := false

func interacted() -> void:
	if visited:
		return
	visited = true
	$AnimationPlayer.current_animation = "die"
