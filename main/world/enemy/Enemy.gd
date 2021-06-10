extends Area2D
class_name Enemy

export(Array, PackedScene) var creatures: Array

func _ready() -> void:
	connect("body_entered", self, "body_entered")

func body_entered(_player: KinematicBody) -> void:
	var instanced_creatures := []
	for i in range(len(creatures)):
		instanced_creatures.append(creatures[i].instance())
	get_viewport().battle_started(instanced_creatures)
	call_deferred("queue_free")
