extends UIController
class_name CreatureCheckScreen

export(NodePath) var off_affinity
export(NodePath) var def_affinity
export(NodePath) var main_vbox
export(NodePath) var stat_bar_container

var creature: Creature
var index := 0
var party: Array
var back_enabled := true
var parent 

func _ready() -> void:
	def_affinity = get_node(def_affinity)
	off_affinity = get_node(off_affinity)
	main_vbox = get_node(main_vbox)
	stat_bar_container = get_node(stat_bar_container)
	disable(false)

func _input(event: InputEvent) -> void:
	if disabled: return
	if event.is_action_pressed("ui_cancel", false) and back_enabled:
		main_viewport.transition.transition_in()
		disable(true)
		yield(main_viewport.transition, "in_finished")
		disable(false)
		return_panel(party[index])
		back.enable(true)
		back.state = "party"
		back.input["FullPartyContainer"].grab_focus_at(index)
		main_viewport.transition.transition_out()
		return
	return_panel(party[index])
	if event.is_action_pressed("ui_left", false):
		index -= 1
	if event.is_action_pressed("ui_right", false):
		index += 1
	if index < 0:
		index = len(party)-1
	elif index >= len(party):
		index = 0
	show_creature(party[index])

func show_creature(creature: Creature) -> void:
	parent = creature.panel.get_parent()
	creature.panel.size_flags_vertical = Control.SIZE_FILL
	creature.panel.update_content()
	for child in stat_bar_container.get_children():
		child.set_stat(creature)
	parent.remove_child(creature.panel)
	main_vbox.add_child(creature.panel)
	main_vbox.move_child(creature.panel, 0)

func return_panel(creature: Creature) -> void:
	creature.panel.size_flags_vertical = Control.SIZE_SHRINK_END
	main_vbox.remove_child(creature.panel)
	parent.add_child(creature.panel)

func input_pressed(key_name: String) -> void:
	pass

func set_affinities() -> void:
	pass
	#off_affinity.set_affinity_panels(creature.off_affinity)
	#def_affinity.set_affinity_panels(creature.def_affinity)

func get_party() -> Array:
	return main_viewport.party.get_node("Active").get_children() + main_viewport.party.get_node("Inactive").get_children()

func enable(show: bool) -> void:
	.enable(show)
	party = get_party()
