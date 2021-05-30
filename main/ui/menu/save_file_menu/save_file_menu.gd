extends UIController
class_name SaveFileMenu
# Main controller for save file menu

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel", false) and visible: 
		main_viewport.transition.transition_in()
		yield(main_viewport.transition, "in_finished")
		main_viewport.hide_menu("SaveFile")
		main_viewport.transition.transition_out()
