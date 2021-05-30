extends KinematicBody

export var speed: int = 3
export var cam_speed: int = 70
export var gravity: int = 12

export (NodePath) var main_viewport

var direction := Vector3()
var cam_direction := Vector3()
var can_move: bool = false

func _ready() -> void:
	main_viewport = get_node(main_viewport)

func _physics_process(delta) -> void:
	if not can_move:
		return
	input()
	move_and_slide($Camera.transform.basis.xform(direction) * speed)
	$Camera.rotation_degrees.y += cam_direction.y * cam_speed * delta
	direction.y = direction.y - gravity if is_on_floor() else 0.0

func input():
	direction = Vector3(0, direction.y, 0)
	cam_direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	if Input.is_action_pressed("move_right"):
		direction.x = 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("turn_right"):
		cam_direction.y -= 1
	if Input.is_action_pressed("turn_left"):
		cam_direction.y += 1
	direction = direction.normalized()
