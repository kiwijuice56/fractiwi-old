extends Area2D
class_name Interactable

export var state: String
var player: KinematicBody2D

func _ready() -> void:
	connect("body_entered", self, "body_entered")
	connect("body_exited", self, "body_exited")

func body_entered(given_player: KinematicBody2D) -> void:
	player = given_player
	player.main_viewport.interact.current_interactable = self
	player.main_viewport.interact.state = state
	player.main_viewport.interact.enable(true)

func body_exited(given_player: KinematicBody2D) -> void:
	player = given_player
	player.main_viewport.interact.current_interactable = null
	player.main_viewport.interact.state = "default"
	player.main_viewport.interact.disable(true)

func interacted() -> void:
	pass

func finish_interaction() -> void:
	pass
