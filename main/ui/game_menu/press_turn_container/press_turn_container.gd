extends Container
class_name PressTurnContainer



func set_turns(full: int, half: int) -> void:
	for i in range(get_child_count()):
		get_child(i).visible = false
	for i in range(full):
		get_child(i).visible = true
	for i in range(get_child_count()-1, full-1-half, -1):
		get_child(i).set_half(true)
