extends Control
class_name UIController
# Untied to any specific nod
# UIControllers function as an abstraction of large sections of UI
# They serve as a controller for InputContainers, as they can change the
# state of other UI elements without many hard coded paths

export(NodePath) var main
export(NodePath) var main_viewport

# Initialized by InputContainers (name: String, reference: InputContainer)
var input := {}
var state := "default"

func _ready() -> void:
	main = get_node(main)
	main_viewport = get_node(main_viewport)

# Each input_container connects to this function
# Used to receive input and change state of UI
func input_pressed(_key_name: String) -> void:
	pass
