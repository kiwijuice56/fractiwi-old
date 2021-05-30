extends ViewportContainer
class_name IntViewportContainer
# Scales viewport only to integer multiples of the resolution
# Modified from https://alvarber.gitlab.io/pixel-perfection-in-godot.html

var resolution = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))
var scaling_factor = 0

func _ready():
	get_viewport().connect("size_changed", self, "on_vp_size_change")
	on_vp_size_change()

func on_vp_size_change():
	var scale_vector = get_viewport().size / resolution
	var new_scaling_factor = max(floor(min(scale_vector[0], scale_vector[1])), 1)
	if new_scaling_factor != scaling_factor:
		scaling_factor = new_scaling_factor
		rect_scale = Vector2(1,1) * scaling_factor
