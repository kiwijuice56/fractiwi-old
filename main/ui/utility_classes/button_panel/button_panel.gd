extends PanelContainer
class_name ButtonPanel
# Adds button functionality to PanelContainers

export var regular_style: Resource
export var focused_style: Resource
export var disabled_style: Resource
export var disbaled_focus_style: Resource
var disabled: bool = false setget set_disabled

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
	if disabled:
		set("custom_styles/panel", disbaled_focus_style)
	else:
		set("custom_styles/panel", focused_style)

func focus_exited() -> void:
	set_process_input(false)
	if disabled:
		set("custom_styles/panel", disabled_style)
	else:
		set("custom_styles/panel", regular_style)

func release_focus() -> void:
	.release_focus()
	focus_exited()

func set_disabled(value: bool) -> void:
	disabled = value
	if disabled:
		set("custom_styles/panel", disabled_style)
	else:
		set("custom_styles/panel", regular_style)
