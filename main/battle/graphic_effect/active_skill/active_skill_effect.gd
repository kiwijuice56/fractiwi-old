extends CanvasLayer
class_name ActiveSkillEffect

export(String, "single", "multiple") var count: String = "single"
export var delay: float
export var anim_name: String

var targets: Array

func _ready() -> void:
	$AnimationPlayer.connect("animation_finished", self, "animation_finished")
	$Sprite.frame = 0
	$AnimationPlayer.current_animation = anim_name

func animation_finished(_anim: String) -> void:
	get_parent().remove_child(self)
	$Sprite.visible = false
	$Sprite.frame = 0
	queue_free()

func start(given_position: Vector2, given_targets: Array) -> void:
	targets = given_targets
	$AudioStreamPlayer.pitch_scale = rand_range(0.9, 1.1)
	$Sprite.global_position = given_position
	$Sprite.visible = true

func impact_point() -> void:
	for target in targets:
		target.target_action()
