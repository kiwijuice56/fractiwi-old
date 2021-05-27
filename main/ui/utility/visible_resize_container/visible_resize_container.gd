extends Container
class_name VisibleResizeContainer

func _ready():
	for child in get_children():
		child.connect("visibility_changed", self, "update_margins")

func update_margins() -> void:
	set_margins_preset(Control.PRESET_BOTTOM_WIDE)
