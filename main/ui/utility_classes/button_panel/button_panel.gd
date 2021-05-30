extends PanelContainer
class_name ButtonPanel
# Adds button functionality to PanelContainers

export var focused_style: Resource
export var disabled_style: Resource
var disabled: bool = false

signal pressed

func _ready() -> void:
	connect("focus_entered", self, "focus_entered")
	connect("focus_exited", self, "focus_exited")
	focus_exited()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("pressed")

func focus_entered() -> void:
	set_process_input(true)
	set("custom_styles/panel", focused_style)

func focus_exited() -> void:
	set_process_input(false)
	set("custom_styles/panel", null)
