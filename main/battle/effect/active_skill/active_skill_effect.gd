extends Sprite
class_name ActiveSkillEffect

export(String, "single", "multiple") var count: String
export var delay: float

var targets: Array

func _ready() -> void:
	visible = false
	$AnimationPlayer.connect("animation_finished", self, "animation_finished")

func animation_finished(anim: String) -> void:
	get_parent().remove_child(self)
	queue_free()

func start(given_position: Vector2, given_targets: Array) -> void:
	visible = true
	targets = given_targets
	global_position = given_position
	$AnimationPlayer.current_animation = "start"

func impact_point() -> void:
	for target in targets:
		target.target_skill_effect()
