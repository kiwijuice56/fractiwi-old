extends ColorRect
class_name DeathCutscene

func play() -> void:
	$AnimationPlayer.current_animation = "death"
