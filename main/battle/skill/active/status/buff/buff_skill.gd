extends StatusSkill
class_name BuffSkill

export(String, "defense", "attack", "hit/eva") var stat := "defense"
export(int, -4, 4) var stages := 0

func get_text() -> String:
	return (("Buff\n" if stages > 0 else "Debuff\n") + stat + "\n%d stages" % abs(stages) ) + description

func use(user: Node, targets: Array, _anim: bool) -> void:
	randomize()
	user.set(cost_type, user.get(cost_type)-cost)
	if user.panel:
		user.panel.update_content()
	var turns_used := 0
	for i in range(len(targets)):
		var current = targets[i].get(stat.replace("/",""))
		if not ( current + stages > 4 or current + stages < -4):
			targets[i].targeted_skill_data = [str(stages), false, false, stat.capitalize(), PointLabel.text_types.BUFF]
			targets[i].set(stat.replace("/",""), targets[i].get(stat.replace("/","")) + stages)
		else:
			targets[i].targeted_skill_data = ["", false, false, "Buffs maximized!" if stages > 0 else "Debuffs maximized!", PointLabel.text_types.BUFF]
		var new_turns_used = turn_logic("normal", false, false)
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

