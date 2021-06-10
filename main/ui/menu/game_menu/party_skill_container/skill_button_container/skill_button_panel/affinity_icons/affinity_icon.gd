extends TextureRect

export var icons: Dictionary

func set_icon(type: String) -> void:
	texture = icons[type]
