extends Sprite
class_name ActiveSkillEffect

export(String, "single", "multiple") var count: String
export var delay: float

var targets: Array

func _ready() -> void:
	$AnimationPlayer.connect("animation_finished", self, "animation_finished")

func animation_finished(anim: String) -> void:
	get_parent().remove_child(self)
	queue_free()

func start(given_position: Vector2, given_targets: Array) -> void:
	$AnimationPlayer.current_animation = "start"
	targets = given_targets
	global_position = given_position
	visible = true

func impact_point() -> void:
	for target in targets:
		target.target_action()
