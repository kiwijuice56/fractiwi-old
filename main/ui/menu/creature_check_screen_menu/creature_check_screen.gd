extends UIController
class_name CreatureCheckScreen

export(NodePath) var off_affinity
export(NodePath) var def_affinity
export(NodePath) var main_vbox
export(NodePath) var stat_bar_container
export(NodePath) var skill_button_container
export(NodePath) var exp_info_container
export(NodePath) var race_label
export(NodePath) var stat_label
export(NodePath) var unlearned_container

var index := 0
var party: Array
var move_enabled := true
var parent 
var levels_left := 0
var skills_left := 0
var stats: Dictionary

signal ready_for_next
signal level_finished
signal confirm
signal skills_learned

func _ready() -> void:
	def_affinity = get_node(def_affinity)
	off_affinity = get_node(off_affinity)
	main_vbox = get_node(main_vbox)
	stat_bar_container = get_node(stat_bar_container)
	skill_button_container = get_node(skill_button_container)
	exp_info_container = get_node(exp_info_container)
	race_label = get_node(race_label)
	stat_label = get_node(stat_label)
	unlearned_container = get_node(unlearned_container)
	main_viewport.connect("battle_end", self, "battle_ended")

func _input(event: InputEvent) -> void:
	if state == "confirm":
		if event.is_action_pressed("ui_accept", false):
			emit_signal("confirm", true)
		if event.is_action_pressed("ui_cancel", false):
			emit_signal("confirm", false)
	if disabled: return
	if not move_enabled: return
	if event.is_action_pressed("ui_cancel", false):
		
		._input(event)
		main_viewport.menu_sound_player.play_sound("Back")
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

func battle_ended(_did_run: bool) -> void:
	yield(main_viewport.transition, "in_finished")
	disable(false)
	stat_label.text = "---"
	state = "default"
	move_enabled = true

func show_creature(creature: Creature) -> void:
	parent = creature.panel.get_parent()
	creature.panel.update_content()
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
	race_label.text = "Race: " + creature.race
	def_affinity.set_affinities("DEF", creature.get_def())
	off_affinity.set_affinities("OFF", creature.get_off())
	unlearned_container.initialize(creature)
	skill_button_container.add_items()

func return_panel(creature: Creature) -> void:
	creature.panel.size_flags_vertical = Control.SIZE_SHRINK_END
	main_vbox.remove_child(creature.panel)
	parent.add_child(creature.panel)
	main_viewport.game.update_party()

func stat_increase(stat: String) -> void:
	main_viewport.menu_sound_player.play_sound("Next")
	party[index].set(stat, party[index].get(stat)+1)
	var stat_index = get_focus_owner().get_index()
	return_panel(party[index])
	show_creature(party[index])
	stats[stat] += 1
	levels_left -= 1
	party[index].set_max_points()
	party[index].panel.update_content()
	stat_label.text = str(levels_left) + " stat points to distribute"
	if levels_left == 0:
		disable(true)
		state = "confirm"
		stat_label.text = "Are you sure?"
		var is_confirmed = yield(self, "confirm")
		if not is_confirmed:
			main_viewport.menu_sound_player.play_sound("Back")
			var changes := 0
			for stat in stats.keys():
				party[index].set(stat, party[index].get(stat) - stats[stat])
				changes += stats[stat]
			return_panel(party[index])
			level_up(party[index], changes, skills_left)
			return
		if skills_left > 0:
			main_viewport.menu_sound_player.play_sound("Next")
			state = "skills"
			learn_skill()
			yield(self, "skills_learned")
		state = "next"
		emit_signal("level_finished")
		yield(main_viewport.transition, "in_finished")
		return_panel(party[index])
		emit_signal("ready_for_next")
	else:
		stat_bar_container.grab_focus_at(stat_index)

func level_up(creature: Creature, levels_changed: int, skills_learned: int) -> void:
	levels_left = levels_changed
	skills_left = skills_learned
	stat_label.text = str(levels_left) + " stat points to distribute"
	index = creature.get_index()
	enable(true)
	stats = {"stre": 0, "magi": 0, "agil": 0, "luck": 0, "vita": 0}
	show_creature(creature)
	move_enabled = false
	stat_bar_container.grab_focus_at(0)

func learn_skill() -> void:
	if input["SkillButtonContainer"].get_child_count() > 6:
		stat_label.text = party[index].creature_name + " is trying to learn a skill .. Select one to forget"
		input["SkillButtonContainer"].grab_focus_at(0)
	else:
		var learned_skill_name = unlearned_container.get_child(0).get_child(1).name_label.text
		party[index].learn_skill("")
		unlearned_container.initialize(party[index])
		skill_button_container.add_items()
		stat_label.text = party[index].creature_name + " learned " + learned_skill_name + "!"
		state = "confirm"
		yield(self, "confirm")
	skills_left -= 1
	if skills_left > 0:
		learn_skill()
	else:
		emit_signal("skills_learned")

func get_party() -> Array:
	return main_viewport.party.get_node("Active").get_children() + main_viewport.party.get_node("Inactive").get_children()

func enable(show: bool) -> void:
	.enable(show)
	party = get_party()
