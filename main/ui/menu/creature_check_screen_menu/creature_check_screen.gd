extends UIController
class_name CreatureCheckScreen

export(NodePath) var off_affinity
export(NodePath) var def_affinity
export(NodePath) var main_vbox
export(NodePath) var stat_bar_container
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
signal fusion_confirmed
signal skill_selected(skill)
signal skills_learned

func _ready() -> void:
	def_affinity = get_node(def_affinity)
	off_affinity = get_node(off_affinity)
	main_vbox = get_node(main_vbox)
	stat_bar_container = get_node(stat_bar_container)
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
		return
	if disabled or state == "replace_skill": return
	if not move_enabled: return
	if event.is_action_pressed("ui_accept", false):
		if state == "default": return
		close()
		if back.state == "fusion_check_screen":
			emit_signal("fusion_confirmed", true)
	if event.is_action_pressed("ui_cancel", false):
		._input(event)
		main_viewport.menu_sound_player.play_sound("Back")
		if state == "check_skills":
			close_check_skills()
			return
		close()
		if back.state == "fusion_check_screen":
			yield(main_viewport.transition, "in_finished")
			emit_signal("fusion_confirmed", false)
		return
	var old_index = index
	if event.is_action_pressed("ui_left", false) and (state == "default" or state == "fusion"):
		index -= 1
	if event.is_action_pressed("ui_right", false) and (state == "default" or state == "fusion"):
		index += 1
	if index == old_index:
		return
	
	if index < 0:
		index = len(party)-1
	elif index >= len(party):
		index = 0
	return_panel(party[old_index])
	show_creature(party[index])

func input_pressed(key: String) -> void:
	if disabled: return
	if state == "fusion" and key == "Change Skills":
		state = "choose_skills"
		set_process_input(false)
		yield(change_skills(), "completed")
		set_process_input(true)
	if state == "replace_skill" and key == "Forget Selected":
		emit_signal("skill_selected", get_focus_owner().skill)
	if state == "replace_skill" and key == "Don't Learn":
		emit_signal("skill_selected", null)

func battle_ended(_did_run: bool) -> void:
	yield(main_viewport.transition, "in_finished")
	disable(false)
	stat_label.text = "---"
	state = "default"
	move_enabled = true

func change_skills() -> void:
	input["HotKeyDescriptionContainer"].hotkeys = {"Select Skill": "up_down", "Add Skill": "ui_accept", "Remove Skill": "ui_cancel", "Finish Change": "ui_accept2"}
	input["HotKeyDescriptionContainer"].add_items()
	input["SkillButtonContainer"].visible = false
	input["FullSkillButtonContainer"].visible = true
	input["FullSkillButtonContainer"].creatures = party
	input["FullSkillButtonContainer"].grab_focus_at(0)
	input["FullSkillButtonContainer"].get_parent().scroll_vertical = 0
	var skill_count = 0
	for creature in party:
		skill_count = min(6, skill_count + len(creature.get_node("Skills").get_skill_names("All")))
	var skill_stack = []
	var success := true
	while len(skill_stack) < skill_count:
		var focus_idx = 0 if not get_focus_owner() else get_focus_owner().get_index()
		var focus_scroll = input["FullSkillButtonContainer"].get_parent().scroll_vertical
		input["FullSkillButtonContainer"].add_items()
		input["FullSkillButtonContainer"].set_selected(skill_stack)
		input["FullSkillButtonContainer"].grab_focus_at(focus_idx)
		input["FullSkillButtonContainer"].get_parent().scroll_vertical = focus_scroll
		var new_skill = yield(input["FullSkillButtonContainer"].choose_skill(), "completed")
		if typeof(new_skill) == TYPE_STRING and new_skill == "Done":
			break
		elif typeof(new_skill) == TYPE_STRING and new_skill == "Cancel":
			if len(skill_stack):
				skill_stack.pop_back()
			else:
				success = false
				break
		else:
			skill_stack.append(new_skill)
	if success:
		var skill_dict := {"Active": [], "Passive": []}
		for skill in skill_stack:
			if skill is ActiveSkill:
				skill_dict["Active"].append(skill.name)
			else:
				skill_dict["Passive"].append(skill.name)
			party[0].get_node("Skills").set_skills(skill_dict)
	if get_focus_owner():
		get_focus_owner().release_focus()
	input["FullSkillButtonContainer"].creatures = []
	input["FullSkillButtonContainer"].add_items()
	state = "fusion"
	input["SkillButtonContainer"].visible = true
	input["FullSkillButtonContainer"].visible = false
	return_panel(party[index])
	show_creature(party[index])
	input["HotKeyDescriptionContainer"].hotkeys = {"Select Creature": "left_right", "Fuse Creature": "ui_accept", "Change Skills": "ui_accept2"}
	input["HotKeyDescriptionContainer"].add_items()

func close_check_skills() -> void:
	state = "default"
	get_focus_owner().release_focus()
	input["HotKeyDescriptionContainer"].enable_input()

func open() -> void:
	input["HotKeyDescriptionContainer"].hotkeys = {"Select Creature": "left_right"}
	input["HotKeyDescriptionContainer"].add_items()
	input["HotKeyDescriptionContainer"].enable_input()
	state = "default"
	move_enabled = true

func open_fusion() -> void:
	input["HotKeyDescriptionContainer"].hotkeys = {"Select Creature": "left_right", "Fuse Creature": "ui_accept", "Change Skills": "ui_accept2"}
	input["HotKeyDescriptionContainer"].add_items()
	input["HotKeyDescriptionContainer"].enable_input()
	state = "fusion"
	move_enabled = true

func close() -> void:
	main_viewport.transition.transition_in()
	disable(true)
	yield(main_viewport.transition, "in_finished")
	return_panel(party[index])
	disable(false)
	input["HotKeyDescriptionContainer"].disable_input()
	back.enable(true)
	if back.state == "check_screen":
		back.state = "party"
		back.input["FullPartyContainer"].grab_focus_at(index)
	main_viewport.transition.transition_out()

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
	main_vbox.get_child(0).get_child(0).get_child(0).texture = creature.texture
	exp_info_container.get_node("LevelLabel").text = "Level: " + str(creature.level)
	exp_info_container.get_node("ExpBar").set_data("EXP", creature.expe, creature.expe_to_level)
	exp_info_container.get_node("NextLabel").text = "Next: " + str(creature.expe_to_level-creature.expe)
	input["SkillButtonContainer"].creature = creature
	race_label.text = "Race: " + creature.race
	def_affinity.set_affinities("DEF", creature.get_def(false))
	off_affinity.set_affinities("OFF", creature.get_off())
	unlearned_container.initialize(creature)
	input["SkillButtonContainer"].add_items()

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
		input["HotKeyDescriptionContainer"].hotkeys = {"Accept": "ui_accept", "Cancel": "ui_cancel"}
		input["HotKeyDescriptionContainer"].add_items()
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
		input["HotKeyDescriptionContainer"].hotkeys = {"Increase Stat": "ui_accept", "Select Stat": "up_down"}
		input["HotKeyDescriptionContainer"].add_items()

func level_up(creature: Creature, levels_changed: int, skills_learned: int) -> void:
	levels_left = levels_changed
	skills_left = skills_learned
	stat_label.text = str(levels_left) + " stat points to distribute"
	index = creature.get_index()
	enable(true)
	stats = {"stre": 0, "magi": 0, "agil": 0, "luck": 0, "vita": 0}
	show_creature(creature)
	input["HotKeyDescriptionContainer"].hotkeys = {"Increase Stat": "ui_accept", "Select Stat": "up_down"}
	input["HotKeyDescriptionContainer"].add_items()
	move_enabled = false
	stat_bar_container.grab_focus_at(0)

func learn_skill() -> void:
	var learned_skill_name = unlearned_container.get_child(0).get_child(1).name_label.text
	var will_confirm := false
	var skill: Skill = null # skill to replace, if necessary
	var learned_skill: Skill = party[index].get_node("UnlearnedSkills").get_child(0)
	set_process_input(false)
	if party[index].get_node("Skills/Active").has_node(learned_skill.name) or party[index].get_node("Skills/Passive").has_node(learned_skill.name):
		party[index].forget_skill()
		stat_label.text = party[index].creature_name + " learned " + learned_skill_name + ", but it already knew this skill .."
		input["HotKeyDescriptionContainer"].hotkeys = {"Accept": "ui_accept"}
	elif input["SkillButtonContainer"].get_child_count() >= 6:
		will_confirm = true
		state = "replace_skill"
		stat_label.text = party[index].creature_name + " is learning a skill, but its slots are full .. Forget one"
		input["SkillButtonContainer"].grab_focus_at(0)
		input["HotKeyDescriptionContainer"].hotkeys = {"Forget Selected": "ui_accept", "Don't Learn": "ui_accept2"}
		input["HotKeyDescriptionContainer"].add_items()
		input["HotKeyDescriptionContainer"].enable_input()
		enable(true)
		skill = yield(self, "skill_selected")
		main_viewport.menu_sound_player.play_sound("Next")
		input["HotKeyDescriptionContainer"].disable_input()
		disable(true)
		if skill:
			party[index].learn_skill(skill)
			stat_label.text = party[index].creature_name + " will forget " + skill.name + " for " + learned_skill_name + ", are you sure?"
		else:
			party[index].forget_skill()
			stat_label.text = party[index].creature_name + " won't learn " + learned_skill_name + ", are you sure?"
		input["HotKeyDescriptionContainer"].hotkeys = {"Accept": "ui_accept", "Cancel": "ui_cancel"}
	else:
		party[index].learn_skill(null)
		stat_label.text = party[index].creature_name + " learned " + learned_skill_name + "!"
		input["HotKeyDescriptionContainer"].hotkeys = {"Accept": "ui_accept"}
	party[index].get_node("Skills").sort_skills()
	unlearned_container.initialize(party[index])
	input["SkillButtonContainer"].add_items()
	input["HotKeyDescriptionContainer"].add_items()
	state = "confirm"
	set_process_input(true)
	var confirmed = yield(self, "confirm")
	if will_confirm and not confirmed:
		if learned_skill.get_parent():
			learned_skill.get_parent().remove_child(learned_skill)
		if skill:
			party[index].get_node("Skills").add_skill(skill)
		party[index].add_unlearned_skill(learned_skill)
		unlearned_container.initialize(party[index])
		party[index].get_node("Skills").sort_skills()
		input["SkillButtonContainer"].add_items()
		learn_skill()
		main_viewport.menu_sound_player.play_sound("Back")
		return
	if skill: skill.queue_free()
	main_viewport.menu_sound_player.play_sound("Next")
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
