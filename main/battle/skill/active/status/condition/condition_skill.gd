extends StatusSkill
class_name ConditionSkill

export(String, "sad", "plague") var condition := "plague"

func get_text() -> String:
	return "Inflicts %s\nHit: %d" % [condition, accuracy]

func use(user: Node, targets: Array, _anim: bool) -> void:
	randomize()
	user.set(cost_type, user.get(cost_type)-cost)
	if user.panel:
		user.panel.update_content()
	var turns_used := 0
	for i in range(len(targets)):
		var target = targets[i]
		var is_miss = is_miss(user, target)
		if target.status == condition:
			is_miss = true
		var def: String = get_def_affinity(target)
		target.targeted_skill_data = [condition, is_miss, false, def, PointLabel.text_types.STATUS]
		var new_turns_used = turn_logic(def, is_miss, false)
		if new_turns_used < 0 or turns_used < 0:
			# warning-ignore:narrowing_conversion
			turns_used = min(new_turns_used, turns_used)
		else:
			# warning-ignore:narrowing_conversion
			turns_used = max(new_turns_used, turns_used)
		if is_miss or def == "null" or def == "absorb":
			continue
		if def == "repel":
			def = get_def_affinity(user)
			user.set("status", condition)
			if not user in targets:
				targets.append(user)
				user.targeted_skill_data = [condition, false, false, def, PointLabel.text_types.STATUS]
		else:
			target.set("status", condition)
	var effect: ActiveSkillEffect = effect_packed.instance()
	var place_timer = Timer.new()
	add_child(place_timer)
	match effect.count:
		"single":
			pass
		"multiple":
			var index := 0
			for target in targets:
				var new_effect := effect_packed.instance()
				add_child(new_effect)
				if not target.panel:
					new_effect.start(target.global_position, [target])
				else:
					var panel_position = target.panel.get_global_transform_with_canvas().get_origin() + (target.panel.rect_size/2)
					new_effect.start(panel_position, [target])
				place_timer.start(effect.delay)
				if index != len(targets)-1:
					yield(place_timer, "timeout")
				index += 1
	yield(targets[len(targets)-1], "target_action_complete")
	call_deferred("remove_child", place_timer)
	place_timer.call_deferred("queue_free")
	emit_signal("use_complete")
	return turns_used
