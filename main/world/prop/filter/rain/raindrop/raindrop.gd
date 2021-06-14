extends Sprite
class_name RainDrop

func _ready() -> void:
	$AnimationPlayer.connect("animation_finished", self, "delete")
	$AnimationPlayer.current_animation = "drop"

func delete(_animation: String) -> void:
	queue_free()
