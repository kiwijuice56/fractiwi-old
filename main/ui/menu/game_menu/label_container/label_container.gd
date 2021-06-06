extends PanelContainer
class_name LabelContainer

export(NodePath) var effect_handler
signal complete

func _ready():
	effect_handler = get_node(effect_handler)

func show_text(text: String) -> void:
	$Label.text = text
	effect_handler.fade(self, "show", 0.15)
	yield(effect_handler, "complete")
	$Timer.start(0.4)
	yield($Timer, "timeout")
	effect_handler.fade(self, "hide", 0.15)
	yield(effect_handler, "complete")
	emit_signal("complete")
