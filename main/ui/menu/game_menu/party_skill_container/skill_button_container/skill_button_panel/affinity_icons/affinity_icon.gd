extends TextureRect
class_name AffinityIcon

export var icons: Dictionary

func set_icon(type: String) -> void:
	texture = icons[type]
