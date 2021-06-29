extends Enemy
class_name RandomMovingEnemy

export var distance_per_move := 16
export var move_time := 0.5
export var average_wait_time := 1.5

func _ready() -> void:
	$Timer.connect("timeout", self, "move")
	$Timer.wait_time = average_wait_time
	$Timer.start()

func body_entered(player: KinematicBody2D) -> void:
	.body_entered(player)
	$Timer.stop()

func restart() -> void:
	$Timer.start()

func move() -> void:
	var possible_dirs := [Vector2.UP, Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN]
	for dir in possible_dirs:
		$RayCast2D.cast_to = dir*distance_per_move
		$RayCast2D.force_raycast_update()
		if $RayCast2D.is_colliding():
			possible_dirs.remove(dir)
	if len(possible_dirs) == 0:
		return
	var dir_idx := randi() % len(possible_dirs)
	$Tween.interpolate_property(self, "position", null,
								position+(possible_dirs[dir_idx]*distance_per_move),
								move_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func pause() -> void:
	$Timer.stop()
	$Tween.stop_all()

func unpause() -> void:
	restart()
