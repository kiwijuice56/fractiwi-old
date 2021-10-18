extends CanvasLayer

var os_names = ["Android", "iOS"]

func _ready():
	if not OS.get_name() in os_names:
		$Control.visible = false
		return
	for button in $Control.get_children():
		button.connect("pressed", self, "pressed", [button.name])
		button.connect("released", self, "released", [button.name])

func pressed(button_name: String):
	var ev = InputEventAction.new()
	ev.action = button_name
	ev.pressed = true
	Input.parse_input_event(ev)

func released(button_name: String):
	var ev = InputEventAction.new()
	ev.action = button_name
	ev.pressed = false
	Input.parse_input_event(ev)
