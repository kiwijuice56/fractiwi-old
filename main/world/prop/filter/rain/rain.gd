extends Filter
class_name Rain

export var raindrop: PackedScene
func _ready():
	$Timer.connect("timeout", self, "add_drop")

func add_drop() -> void:
	var new_drop = raindrop.instance()
	add_child(new_drop)
	new_drop.position = Vector2(rand_range(0,490), rand_range(0,276))
