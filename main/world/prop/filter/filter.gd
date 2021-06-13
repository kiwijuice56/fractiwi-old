extends CanvasLayer
class_name Filter

func _ready():
	$AnimationPlayer.play($AnimationPlayer.get_animation_list()[0])
