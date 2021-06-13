extends Sprite
class_name DynamicScenery

export var refresh_rate: float

func _ready() -> void:
	$Timer.connect("timeout", self, "update")
	$Timer.wait_time = refresh_rate
	$Timer.start()

func update() -> void:
	pass
