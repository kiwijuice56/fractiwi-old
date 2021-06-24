extends Area2D
class_name LoopArea

func _ready():
	connect("body_exited", self, "body_exited")
	connect("area_exited", self, "area_exited")

func body_exited(body: PhysicsBody2D) -> void:
	object_exited(body)

func area_exited(area: Area2D) -> void:
	object_exited(area)

func object_exited(object: Node2D) -> void:
	var extents = $CollisionShape2D.shape.extents
	if not object: return
	if object.has_node("Tween"):
		object.get_node("Tween").stop_all()
	if object.global_position.x > self.global_position.x + extents.x:
		object.global_position.x -= extents.x*2
	elif object.global_position.x < self.global_position.x - extents.x:
		object.global_position.x += extents.x*2
	print(object.global_position, global_position, extents)
	if object.global_position.y > self.global_position.y + extents.y: #UNDER
		object.global_position.y -= extents.y*2
	elif object.global_position.y < self.global_position.y - extents.y: #ABOVE
		object.global_position.y += extents.y*2
