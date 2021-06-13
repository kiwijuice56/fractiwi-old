extends Area2D
class_name Enemy

export(Array, PackedScene) var creatures: Array
export var anim_name: String

func _ready() -> void:
	$AnimationPlayer.current_animation = anim_name
	connect("body_entered", self, "body_entered")

func body_entered(_player: KinematicBody) -> void:
	var instanced_creatures := []
	for i in range(len(creatures)):
		instanced_creatures.append(creatures[i].instance())
	get_viewport().battle_started(instanced_creatures)
	yield(get_viewport().transition, "in_finished")
	call_deferred("queue_free")
