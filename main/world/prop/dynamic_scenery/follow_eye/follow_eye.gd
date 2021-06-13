extends DynamicScenery
class_name FollowEye

func update() -> void:
	var dir = (get_viewport().world_node.player.global_position - global_position).normalized()
	dir = int(rad2deg((PI/4) * round(Vector2(1,0).angle_to(dir) / (PI/4))))
	match dir:
		0:frame = 3
		45: frame = 4
		90: frame = 5
		135: frame = 6 
		180: frame = 7
		-135: frame = 0
		-90: frame = 1
		-45: frame = 2
