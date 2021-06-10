extends ActiveSkill
class_name PointSkill

export(int, 0, 100) var critical := 0
export(int, -100, 100) var power := 0

func use(user: Creature, targets: Array, _anim: bool) -> void:
	var turns_used:= 0
	for i in range(len(targets)):
		var target = targets[i]
		var is_miss = is_miss(user, target)
		var is_crit = is_crit(user, target)
		var def: String = get_def_affinity(target)
		var off: int = get_off_affinity(target)
		var point_change = calculate_points(user, target, def, off, is_crit)
		target.targeted_skill_data = [point_change, is_miss, is_crit, def]
		var new_turns_used = turn_logic(def, is_miss, is_crit)
		if new_turns_used < 0 or turns_used < 0:
			# warning-ignore:narrowing_conversion
			turns_used = min(new_turns_used, turns_used)
		else:
			# warning-ignore:narrowing_conversion
			turns_used = max(new_turns_used, turns_used)
		if is_miss:
			continue
		if def == "repel":
			def = get_def_affinity(user)
			point_change = calculate_points(user, user, def, off, is_crit)
			user.hp += point_change
			if not user in targets:
				targets.append(user)
				user.targeted_skill_data = [point_change, false, is_crit, def]
			else:
				user.targeted_skill_data[0] += point_change
		else:
			target.hp += point_change
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
	return turns_used

func is_crit(_user: Creature, _target: Creature) -> bool:
	return rand_range(0,1) <= critical/100.0

func calculate_points(user: Creature, target: Creature, def: String, off: int, is_crit: bool) -> int:
	var neg = power < 0
	var base = abs(power) + (user.level/3.0) + user.stre - (target.level/5.0)
	if def == "weak":
		base *= 2
	elif def == "resist":
		base *= 0.5
	elif def == "absorb":
		base *= -1
	elif def == "null":
		base *= 0
	base *= (off/100.0)
	base *= 2 if is_crit else 1
	return base * -1 if neg else 1
