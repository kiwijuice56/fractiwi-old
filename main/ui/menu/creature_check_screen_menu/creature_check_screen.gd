extends UIController
class_name CreatureCheckScreen

export(NodePath) var off_affinity
export(NodePath) var def_affinity
export(NodePath) var main_vbox
export(NodePath) var stat_bar_container
export(NodePath) var skill_button_container
export(NodePath) var exp_info_container

var index := 0
var party: Array
var move_enabled := true
var parent 
var levels_left := 0

signal level_finished

func _ready() -> void:
	def_affinity = get_node(def_affinity)
	off_affinity = get_node(off_affinity)
	main_vbox = get_node(main_vbox)
	stat_bar_container = get_node(stat_bar_container)
	skill_button_container = get_node(skill_button_container)
	exp_info_container = get_node(exp_info_container)
	disable(false)

func _input(event: InputEvent) -> void:
	if disabled: return
	if not move_enabled: return
	if event.is_action_pressed("ui_cancel", false):
		._input(event)
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
	var old_index = index
	
	if event.is_action_pressed("ui_left", false):
		index -= 1
	if event.is_action_pressed("ui_right", false):
		index += 1
	if index == old_index:
		return
	
	if index < 0:
		index = len(party)-1
	elif index >= len(party):
		index = 0
	return_panel(party[old_index])
	show_creature(party[index])

func show_creature(creature: Creature) -> void:
	parent = creature.panel.get_parent()
	creature.panel.size_flags_vertical = Control.SIZE_FILL
	creature.panel.update_content()
	stat_bar_container.add_items()
	stat_bar_container.update_all(creature)
	parent.remove_child(creature.panel)
	main_vbox.add_child(creature.panel)
	main_vbox.move_child(creature.panel, 1)
	main_vbox.get_child(0).texture = creature.texture
	exp_info_container.get_node("LevelLabel").text = "Level: " + str(creature.level)
	exp_info_container.get_node("ExpBar").set_data("EXP", creature.expe, creature.expe_to_level)
	exp_info_container.get_node("NextLabel").text = "Next: " + str(creature.expe_to_level-creature.expe)
	skill_button_container.creature = creature
	def_affinity.set_affinities("DEF", creature.def_affinity)
	off_affinity.set_affinities("OFF", creature.off_affinity)
	skill_button_container.add_items()
	

func return_panel(creature: Creature) -> void:
	creature.panel.size_flags_vertical = Control.SIZE_SHRINK_END
	main_vbox.remove_child(creature.panel)
	parent.add_child(creature.panel)

func stat_increase(stat: String) -> void:
	party[index].set(stat, party[index].get(stat)+1)
	return_panel(party[index])
	show_creature(party[index])
	levels_left -= 1
	disable(true)
	if levels_left == 0:
		main_viewport.transition.transition_in()
		yield(main_viewport.transition, "in_finished")
		disable(false)
		return_panel(party[index])
		move_enabled = true
		main_viewport.transition.transition_out()
		emit_signal("level_finished")

func level_up(creature: Creature, levels: int) -> void:
	index = creature.panel.get_index()
	levels_left = levels
	show_creature(creature)
	enable(true)
	move_enabled = false
	stat_bar_container.grab_focus_at(0)

func get_party() -> Array:
	return main_viewport.party.get_node("Active").get_children() + main_viewport.party.get_node("Inactive").get_children()

func enable(show: bool) -> void:
	.enable(show)
	party = get_party()
