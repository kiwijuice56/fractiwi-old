extends CanvasLayer

func _ready():
	if not OS.has_touchscreen_ui_hint():
		set_process_input(false)
	for button in $Control2.get_children():
		button.connect("pressed", self, "pressed", [button.name])
		button.connect("released", self, "released", [button.name])

func _input(event):
	if event is InputEventMouseMotion:
		if (event.position - $Control/joystick.position).length() > 42:
			return
		var up = InputEventAction.new()
		var left = InputEventAction.new()
		var right = InputEventAction.new()
		var down = InputEventAction.new()
		up.action = "ui_up"
		down.action = "ui_down"
		left.action = "ui_left"
		right.action = "ui_right"
		up.pressed = true if event.position.y > $Control/joystick.position.y else false
		down.pressed = true if event.position.y < $Control/joystick.position.y else false
		left.pressed = true if event.position.x < $Control/joystick.position.x else false
		right.pressed = true if event.position.x > $Control/joystick.position.x else false
		Input.parse_input_event(up)
		Input.parse_input_event(left)
		Input.parse_input_event(right)
		Input.parse_input_event(down)

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
