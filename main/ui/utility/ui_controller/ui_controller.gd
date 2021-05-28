extends Control
class_name UIController

var input := {}
var state := "default"

# Each input_container connects to this function
# Used to receive input and change state of UI
func input_pressed(_key_name: String) -> void:
	pass
