extends Control
class_name UIController
# UIControllers function as an abstraction of large sections of UI -  
# essentially act as one menu
# They contain the mess of many hard coded paths into one node that is 
# accessible through functions
# They serve as a controller for InputContainers, as they can change the
# state of other UI elements 

export(NodePath) var main_viewport
export var next_sound := false
export var back_sound := false
export var select_sound := false
export var override_next_sound := false
export var override_back_sound := false
export var override_select_sound := false

# Initialized by InputContainers (name: String, reference: InputContainer)
var input := {}
var state := "default"
var back: UIController
var disabled := false

func _ready() -> void:
	main_viewport = get_node(main_viewport)

func _input(event: InputEvent) -> void:
	if disabled or "open" in self and not get("open"): return
	#print(name)
	if select_sound and not override_select_sound:
		for key in ["left", "right", "up", "down"]:
			if event.is_action_pressed("ui_"+key, false):
				main_viewport.menu_sound_player.play_sound("Select")
	if event.is_action_pressed("ui_accept", false) and next_sound and not override_next_sound:
		main_viewport.menu_sound_player.play_sound("Next")
	if event.is_action_pressed("ui_cancel", false) and back_sound and not override_back_sound:
		main_viewport.menu_sound_player.play_sound("Back")

# Each input_container connects to this function
# Used to receive input and change state of UI
func input_pressed(_key_name: String) -> void:
	if disabled: return

func enable(show: bool) -> void:
	disabled = false
	if show: visible = true

func disable(show: bool) -> void:
	disabled = true
	if is_inside_tree() and get_focus_owner() and is_a_parent_of(get_focus_owner()):
		get_focus_owner().release_focus()
	if not show: visible = false
