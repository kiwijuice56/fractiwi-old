extends Sprite
class_name Creature
# Contains data for a creature and functions to edit them

export(String, "Demon", "Human", "Inanimate", "Beast") var race: String = "Human"
export var level: int
export var stre: int
export var magi: int
export var vita: int
export var luck: int
export var agil: int
export var def_affinity: Dictionary
export var off_affinity: Dictionary

var hp: int = 10
var max_hp: int = 10
var mp: int = 20
var max_mp: int
var status := "ok"

var expe := 0
var expe_to_level := 25
export var expe_given := 10

signal target_action_complete
signal death

# Set by skills targeted at this creature to use in appropriate time of animation
var targeted_skill_data: Array
var panel: ButtonPanel

# Returns press turns used
func do_turn(same: Array, opposite: Array) -> int:
	var action = $AI.do_turn(same, opposite, self)
	if $AI.yielded: # if player, ai must be yielded for
		action = yield(action, "completed")
	else: # if enemy, flash self to indicate turn
		$AnimationPlayer.current_animation = "my_turn"
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
	return 0

func target_action() -> void:
	if not panel:
		$AnimationPlayer.current_animation = "hurt_normal"
		$PointLabel.set_point_text(targeted_skill_data[0], targeted_skill_data[1], targeted_skill_data[2], targeted_skill_data[3])
		$PointLabel.get_node("AnimationPlayer").current_animation = "show"
	else:
		panel.get_node("AnimationPlayer").current_animation = "hurt_normal"
		panel.get_node("PointLabel").set_point_text(targeted_skill_data[0], targeted_skill_data[1], targeted_skill_data[2], targeted_skill_data[3])
		panel.get_node("PointLabel/AnimationPlayer").current_animation = "show"
	targeted_skill_data = []
	var function = check_hp()
	if panel: panel.update_content()
	if function:
		yield(function, "completed")
	emit_signal("target_action_complete")

func check_hp() -> void:
	if hp <= 0:
		hp = 0
		death()
		yield(self, "death")

func death() -> void:
	get_parent().get_parent().expe += expe_given #battle queue
	if panel:
		var viewport = get_viewport()
		get_parent().remove_child(self)
		viewport.party.get_node("Inactive").add_child(self)
		panel.get_node("AnimationPlayer").stop()
		panel.get_node("AnimationPlayer").current_animation = "death"
		yield(panel.get_node("AnimationPlayer"), "animation_finished")
		viewport.game.update_party()
		status = "dead"
		hp = 0
		emit_signal("death")
		if name == "Yun":
			get_tree().quit()
	else:
		$AnimationPlayer.stop()
		$AnimationPlayer.current_animation = "death"
		yield($AnimationPlayer, "animation_finished")
		get_parent().remove_child(self)
		emit_signal("death")
		queue_free()

func to_dict() -> Dictionary:
	var skills = {"Passive": $Skills.get_skill_names("Passive"),
				  "Active": $Skills.get_skill_names("Active")}
	var stats = {"level": level, "stre": stre, "magi": magi, "vita": vita,
				 "luck": luck, "agil": agil, "hp": hp, "mp": mp}
	return {"skills": skills, "stats": stats}

func set_stats(data: Dictionary) -> void:
	for stat in data.keys():
		set(stat, data[stat])
	set_max_points()

func set_level() -> int:
	var levels_changed := 0
	while expe > expe_to_level:
		expe -= expe_to_level
		levels_changed += 1
	level += levels_changed
	set_max_points()
	return levels_changed

func set_max_points() -> void:
	max_hp = (level + vita) * 6
	max_mp = (level*4) + (magi*2)
	if panel: panel.update_content()

func heal_points() -> void:
	set_max_points()
	hp = max_hp
	mp = max_mp
	if panel: panel.update_content()
