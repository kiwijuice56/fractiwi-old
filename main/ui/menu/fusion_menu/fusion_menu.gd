extends UIController
class_name FusionMenu

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel", false) and not disabled: 
		main_viewport.transition.transition_in()
		._input(event)
		disable(true)
		yield(main_viewport.transition, "in_finished")
		disable(false)
		back.enable(true)
		main_viewport.transition.transition_out()
