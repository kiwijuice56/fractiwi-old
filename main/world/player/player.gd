extends KinematicBody2D

export var speed: int = 3

export (NodePath) var main_viewport
export var effect_textures: Dictionary

var effect := "Normal"
var surface := "Normal"
var direction := Vector2()
var can_move: bool = false

func _ready() -> void:
	main_viewport = get_node(main_viewport)
	disable_collision()

func _physics_process(_delta) -> void:
	if not can_move:
		$AnimationPlayer.current_animation = "[stop]"
		return
	input()
	move_and_slide(direction*speed)

func input():
	direction = Vector2()
	if Input.is_action_pressed("move_forward"):
		direction.y -= 1
	if Input.is_action_pressed("move_backward"):
		direction.y += 1
	if Input.is_action_pressed("move_right"):
		direction.x = 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	direction = direction.normalized()
	$AnimationPlayer.current_animation = animation()

func animation() -> String:
	var current_animation := "[stop]"
	if direction.y > 0:
		current_animation = "walk_down"
	elif direction.y < 0:
		current_animation = "walk_up"
	elif direction.x > 0:
		current_animation = "walk_right"
	elif direction.x < 0:
		current_animation = "walk_left"
	return current_animation

func set_effect(new_effect: String) -> void:
	effect = new_effect
	can_move = false
	get_viewport().game.can_open = false
	get_viewport().items.current_effect = effect
	set_physics_process(false)
	$AnimationPlayer.play("set_effect")
	yield($AnimationPlayer, "animation_finished")
	set_physics_process(true)
	can_move = true
	get_viewport().game.can_open = true

func update_sprite() -> void:
	$Sprite.texture = effect_textures[effect]

func disable_collision() -> void:
	set_collision_layer(0)

func enable_collision() -> void:
	set_collision_layer(1)
