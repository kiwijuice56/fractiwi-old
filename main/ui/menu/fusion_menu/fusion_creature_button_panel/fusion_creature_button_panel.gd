extends ButtonPanel
class_name FusionCreatureButtonPanel

export var selected_style: StyleBox
export var selected_focus_style: StyleBox

var selected := false setget set_selected

func focus_entered() -> void:
	set_process_input(true)
	if disabled:
		set("custom_styles/panel", disbaled_focus_style)
	elif selected:
		set("custom_styles/panel", selected_focus_style)
	else:
		set("custom_styles/panel", focused_style)

func focus_exited() -> void:
	set_process_input(false)
	if disabled:
		set("custom_styles/panel", disabled_style)
	elif selected:
		set("custom_styles/panel", selected_style)
	else:
		set("custom_styles/panel", regular_style)

func set_selected(val: bool) -> void:
	selected = val
	if selected:
		set("custom_styles/panel", selected_style)
	else:
		set("custom_styles/panel", regular_style)

func initialize(creature: Creature) -> void:
	$HBoxContainer/Race.text = creature.race
	$HBoxContainer/Name.text = creature.creature_name
	$HBoxContainer/Level.text = "lvl " + str(creature.level)
