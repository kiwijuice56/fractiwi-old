extends Control
class_name UIController
# UIControllers function as an abstraction of large sections of UI -  
# essentially act as one menu
# They contain the mess of many hard coded paths into one node that is 
# accessible through functions
# They serve as a controller for InputContainers, as they can change the
# state of other UI elements 

export(NodePath) var main_viewport

# Initialized by InputContainers (name: String, reference: InputContainer)
var input := {}
var state := "default"
var back: UIController
var disabled := false

func _ready() -> void:
	main_viewport = get_node(main_viewport)

func _input(_event: InputEvent) -> void:
	if disabled: return

# Each input_container connects to this function
# Used to receive input and change state of UI
func input_pressed(_key_name: String) -> void:
	if disabled: return

func enable(show: bool) -> void:
	disabled = false
	if show: visible = true

func disable(show: bool) -> void:
	disabled = true
	if not show: visible = false
