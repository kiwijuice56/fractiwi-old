extends StatusSkill
class_name ConcentrateSkill

func get_text() -> String:
	return description

func use(user: Node, targets: Array, _anim: bool) -> void:
	randomize()
	user.set(cost_type, user.get(cost_type)-cost)
	if user.panel:
		user.panel.update_content()
	var turns_used := 0
	for i in range(len(targets)):
		var target = targets[i]
		if not target.concentrate:
			target.targeted_skill_data = [true, false, false, "", "", PointLabel.text_types.CONCENTRATE]
			target.concentrate = true
		else:
			target.targeted_skill_data = [false, false, false, "", "", PointLabel.text_types.CONCENTRATE]
		var new_turns_used = turn_logic("regular", false, false)
		if new_turns_used < 0 or turns_used < 0:
			# warning-ignore:narrowing_conversion
			turns_used = min(new_turns_used, turns_used)
		else:
			# warning-ignore:narrowing_conversion
			turns_used = max(new_turns_used, turns_used)
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
