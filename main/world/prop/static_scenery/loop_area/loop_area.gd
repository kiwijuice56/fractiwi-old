extends Area2D
class_name LoopArea

func _ready():
	connect("body_exited", self, "body_exited")

func body_exited(player: KinematicBody2D) -> void:
	var extents = $CollisionShape2D.shape.extents
	if player.global_position.x > self.global_position.x + extents.x:
		player.global_position.x -= extents.x*2
	elif player.global_position.x < self.global_position.x - extents.x:
		player.global_position.x += extents.x*2
	if player.global_position.y > self.global_position.y + extents.y:
		player.global_position.y -= extents.y*2
	elif player.global_position.y < self.global_position.y - extents.y:
		player.global_position.y += extents.y*2
