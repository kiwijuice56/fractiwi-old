extends Sprite
class_name Creature
# Contains data for a creature and functions to edit them

export(String, "Human", "Object", "Beast", "Spirit", "Demon", "Angel", "Plant") var race: String = "Human"
export var creature_name: String
export var level: int
var base_level: int
export var stre: int
export var magi: int
export var vita: int
export var luck: int
export var agil: int
export var def_affinity: Dictionary
export var off_affinity: Dictionary
var extend_def_affinity: Dictionary
var extend_off_affinity: Dictionary

var hp: int = 70
var max_hp: int = 10
var mp: int = 31
var max_mp: int
var status := "ok"
var is_tamed := false
export var is_boss := false

var attack: int = 0
var defense: int = 0
var hiteva: int = 0
var focus := false
var concentrate := false

var item_use := false
var expe := 0
var expe_to_level := 0
var age := 0

signal target_action_complete
signal death
signal hp_ratio_updated

# Set by skills targeted at this creature to use in appropriate time of animation
var targeted_skill_data: Array
var panel: ButtonPanel

func _ready() -> void:
	offset = Vector2()
	set_max_points()
	set_expe_to_level()
	check_hp()
	update_passive_skills()

func get_def(get_extended: bool) -> Dictionary:
	if get_extended:
		var combined_affinity := {}
		for key in def_affinity.keys():
			combined_affinity[key] = def_affinity[key]
		for key in extend_def_affinity.keys():
			combined_affinity[key] = extend_def_affinity[key]
		return combined_affinity
	return def_affinity

func get_off() -> Dictionary:
	return off_affinity

# Returns press turns used
func do_turn(same: Array, opposite: Array) -> int:
	var action = $AI.do_turn(same, opposite, self)
	if $AI.yielded: # if player, ai must be yielded for
		action = yield(action, "completed")
	else: # if enemy, flash self to indicate turn
		$AnimationPlayer.current_animation = "my_turn"
		$NextPlayer.playing = true
		yield($AnimationPlayer, "animation_finished")
	var tag: String = action[0]
	var object: Node = action[1]
	var targets: Array = action[2]
	if tag == "Summon" or tag == "Return" or tag == "Pass":
		get_viewport().game.label_container.show_text(tag)
		yield(get_viewport().game.label_container, "complete")
		return 1
	if tag == "Skill":
		get_viewport().game.label_container.show_text(object.name)
		return yield(object.use(self, targets, true), "completed")
	if tag == "Run":
		if run_attempt():
			get_viewport().game.label_container.show_text("Yun ran!")
			yield(get_viewport().game.label_container, "complete")
			return 8
		else:
			get_viewport().game.label_container.show_text("Yun couldn't escape!")
			yield(get_viewport().game.label_container, "complete")
			return -2
	if tag == "Recruit":
		match recruit_attempt(targets):
			"higher level":
				get_viewport().game.label_container.show_text("Fail .. It was too strong")
				yield(get_viewport().game.label_container, "complete")
				return -1
			"in party":
				get_viewport().game.label_container.show_text("Fail .. You have this creature")
				yield(get_viewport().game.label_container, "complete")
				return -1
			"fail":
				get_viewport().game.label_container.show_text("Fail .. It attacked!")
				yield(get_viewport().game.label_container, "complete")
				return -1
			"boss":
				get_viewport().game.label_container.show_text("Fail .. Its cannot join you ")
				yield(get_viewport().game.label_container, "complete")
				return -1
			"stock":
				get_viewport().game.label_container.show_text("Fail .. You have no space for creatures")
				yield(get_viewport().game.label_container, "complete")
				return -1
			"success":
				get_viewport().game.label_container.show_text("Success .. " + targets[0].creature_name + " joined you!")
				yield(get_viewport().game.label_container, "complete")
				targets[0].get_parent().remove_child(targets[0])
				get_viewport().party.get_node("Inactive").add_child(targets[0])
				targets[0].is_tamed = true
				targets[0].name = targets[0].creature_name
				targets[0].get_node("AI").switch_script()
				targets[0].heal_points()
				return 0
	return 0

func run_attempt() -> bool:
	randomize()
	return rand_range(0,1) < .35+ ((luck+agil)/120.0)

func recruit_attempt(targets: Array) -> String:
	if targets[0].is_boss:
		return "boss"
	if targets[0].level > level:
		return "higher level"
	var names := []
	for child in get_viewport().party.get_node("Active").get_children() + get_viewport().party.get_node("Inactive").get_children():
		names.append(child.creature_name)
	if targets[0].creature_name in names:
		return "in party"
	if get_viewport().party.get_node("Active").get_child_count() + get_viewport().party.get_node("Inactive").get_child_count() >= 12:
		return "stock"
	randomize()
	if rand_range(0,1) < .30+ ((luck)/60.0):
		return "success"
	return "fail"

func target_action() -> void:
	if not panel:
		if targeted_skill_data[1]:
			$AnimationPlayer.current_animation = "miss"
		else:
			print(targeted_skill_data[3])
			if targeted_skill_data[3] == "weak":
				$AnimationPlayer.current_animation = "hurt_weak"
			elif targeted_skill_data[3] == "resist":
				$AnimationPlayer.current_animation = "hurt_resist"
			else:
				$AnimationPlayer.current_animation = "hurt_normal"
		$PointLabel.set_point_text(targeted_skill_data[0], targeted_skill_data[1], targeted_skill_data[2], targeted_skill_data[3], targeted_skill_data[4], targeted_skill_data[5])
		$PointLabel.get_node("AnimationPlayer").current_animation = "show"
	else:
		panel.get_node("AnimationPlayer").current_animation = "hurt_normal"
		panel.get_node("PointLabel").set_point_text(targeted_skill_data[0], targeted_skill_data[1], targeted_skill_data[2], targeted_skill_data[3], targeted_skill_data[4], targeted_skill_data[5])
		panel.get_node("PointLabel/AnimationPlayer").current_animation = "show"
	targeted_skill_data = []
	var function = check_hp()
	emit_signal("hp_ratio_updated", hp / float(max_hp))
	if panel: panel.update_content()
	if function:
		yield(function, "completed")
	elif not panel:
		yield($AnimationPlayer, "animation_finished")
	else:
		yield(panel.get_node("AnimationPlayer"), "animation_finished")
	emit_signal("target_action_complete")

func reset_buffs() -> void:
	attack = 0
	defense = 0
	hiteva = 0
	focus = false
	concentrate = false

func check_hp() -> void:
	if hp <= 0:
		hp = 0
		death()
		yield(self, "death")

func death() -> void:
	status = "dead"
	if panel:
		var viewport = get_viewport()
		get_parent().remove_child(self)
		viewport.party.get_node("Inactive").add_child(self)
		panel.get_node("AnimationPlayer").stop()
		panel.get_node("AnimationPlayer").current_animation = "death"
		yield(panel.get_node("AnimationPlayer"), "animation_finished")
		emit_signal("death")
		if name == "Yun":
			get_viewport().death()
	elif not is_tamed:
		var queue = get_parent().get_parent()
		var level_dif = queue.get_node("PlayerParty").get_child(0).level - level
		var multiplier = 1
		if level_dif > 0:
			multiplier = 1 / max(1, abs(level_dif/3.0))
		else:
			multiplier = 1 * max(1, abs(level_dif/3.0))
		var expe_given = (queue.get_node("PlayerParty").get_child(0).expe_to_level/6)
		print(multiplier, " ",expe_given)
		var money_given = rand_range(15,20)
		queue.expe += int(expe_given * multiplier * (4.0 if is_boss else 1.0))
		get_viewport().items.money += int(money_given * multiplier * (4.0 if is_boss else 1.0))
		$AnimationPlayer.stop()
		$AnimationPlayer.current_animation = "death"
		yield($AnimationPlayer, "animation_finished")
		get_parent().remove_child(self)
		emit_signal("death")
		queue_free()

func update_passive_skills() -> void:
	for skill in get_node("Skills/Passive").get_children():
		skill.modify_creature(self)

func learn_skill(to_replace: Skill) -> void:
	if to_replace:
		to_replace.get_parent().remove_child(to_replace)
	var skill = get_node("UnlearnedSkills").get_child(0)
	get_node("UnlearnedSkills").remove_child(skill)
	get_node("Skills").add_skill(skill)
	update_passive_skills()

func forget_skill() -> void:
	var skill = get_node("UnlearnedSkills").get_child(0)
	get_node("UnlearnedSkills").remove_child(skill)

func add_unlearned_skill(skill: Skill) -> void:
	get_node("UnlearnedSkills").add_child(skill)
	get_node("UnlearnedSkills").move_child(skill, 0)

func to_dict() -> Dictionary:
	var skills = {"Passive": $Skills.get_skill_names("Passive"),
					"Active": $Skills.get_skill_names("Active"),
					"Unlearned": get_node("UnlearnedSkills").get_skill_names("All"),
					"Skill Levels": get_node("UnlearnedSkills").skill_levels}
	var stats = {"level": level, "stre": stre, "magi": magi, "vita": vita,
				 "luck": luck, "agil": agil, "hp": hp, "mp": mp,
				  "expe": expe, "age": age}
	return {"skills": skills, "stats": stats}

func set_stats(data: Dictionary) -> void:
	base_level = level
	for stat in data.keys():
		set(stat, data[stat])
	set_max_points()
	set_expe_to_level()

func set_level() -> Array:
	var levels_changed := 0
	var skills_learned := 0
	while expe >= expe_to_level:
		expe -= expe_to_level
		levels_changed += 1
		age += 1
		set_expe_to_level()
	if levels_changed != 0:
		level += levels_changed
		skills_learned = get_node("UnlearnedSkills").skills_to_learn(self)
	set_max_points()
	return [levels_changed, skills_learned]

func set_expe_to_level() -> void:
	expe_to_level = ((25*age) + (25*level))

func set_max_points() -> void:
	max_hp = (level + vita) * 7
	max_mp = (level * 4) + (magi * 3)

func heal_points() -> void:
	set_max_points()
	hp = max_hp
	mp = max_mp
	if panel: panel.update_content()
