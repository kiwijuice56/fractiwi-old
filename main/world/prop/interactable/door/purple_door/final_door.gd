extends Door
class_name FinalDoor

func _ready() -> void:
	if len(get_viewport().items.effects) == 5:
		visible = true
		global_position = Vector2(184, 250)
	else:
		global_position = Vector2(1000, 250)
