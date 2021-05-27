extends Container
class_name InputContainer
# Abstract class from which custom, input-related containers extend
# Can be placed on any container - HBoxContainer, VBoxContainer, etc.
# Purpose is to make input implementation consistent and modular within the controller 

export(NodePath) var controller

func _ready() -> void:
	controller = get_node(controller)
	controller.input[name] = self
	yield(get_tree().root, "ready")
	add_items()
	disable_input()

func add_items() -> void:
	pass

func disable_input() -> void:
	set_process_input(false)
func enable_input() -> void:
	set_process_input(true)
func grab_focus_at(index: int) -> void:
	get_child(index).grab_focus()
