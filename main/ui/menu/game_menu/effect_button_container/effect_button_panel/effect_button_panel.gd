extends ButtonPanel
class_name EffectButtonPanel

export var icons: Dictionary

func initialize(effect: String) -> void:
	$TextureRect.texture = icons[effect]
	$Label.text = effect
	name = effect
