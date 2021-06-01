extends Area
class_name Interactable

export(NodePath) var room 
export var state: String

func _ready() -> void:
	room = get_node(room)
	connect("body_entered", self, "body_entered")
	connect("body_exited", self, "body_exited")

func body_entered(player: KinematicBody) -> void:
	player.main_viewport.interact.current_interactable = self
	player.main_viewport.interact.state = state
	player.main_viewport.interact.enable(true)

func body_exited(player: KinematicBody) -> void:
	player.main_viewport.interact.current_interactable = null
	player.main_viewport.interact.state = "default"
	player.main_viewport.interact.disable(false)

func interacted() -> void:
	pass

func finish_interaction() -> void:
	pass
