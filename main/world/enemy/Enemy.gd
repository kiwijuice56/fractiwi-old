extends Area2D
class_name Enemy

export(Array, PackedScene) var creatures: Array
export var anim_name: String

func _ready() -> void:
	$AnimationPlayer.current_animation = anim_name
	connect("body_entered", self, "body_entered")

func restart() -> void:
	pass

func body_entered(player: KinematicBody2D) -> void:
	player.can_move = false
	get_viewport().game.can_open = false
	get_viewport().world_node.current_enemy = self
	var instanced_creatures := []
	for i in range(len(creatures)):
		instanced_creatures.append(creatures[i].instance())
	get_viewport().battle_started(instanced_creatures)

