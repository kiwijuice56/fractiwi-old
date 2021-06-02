extends Area
class_name Enemy

export(Array, PackedScene) var creatures: Array

func _ready() -> void:
	connect("body_entered", self, "body_entered")

func body_entered(_player: KinematicBody) -> void:
	get_viewport().battle_started(creatures)
	call_deferred("queue_free")
