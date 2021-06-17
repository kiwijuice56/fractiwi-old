extends Control
class_name VisionEffects

func _ready() -> void:
	get_viewport().connect("battle_start", self, "battle_started")
	get_viewport().connect("battle_end", self, "battle_ended")

func set_effect(effect: String, on: bool) -> void:
	match effect:
		"tunnel":
			$TunnelVision.visible = on

func battle_started(_creatures: Array) -> void:
	set_effect("tunnel", true)

func battle_ended(_did_run: bool) -> void:
	set_effect("tunnel", false)
