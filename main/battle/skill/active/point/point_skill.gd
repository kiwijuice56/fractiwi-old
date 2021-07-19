extends ActiveSkill
class_name PointSkill

export var can_crit := true
export(int, 0, 100) var critical := 0
export(int, -100, 100) var power := 0
export(String, "stre", "magi", "luck", "vita") var stat := "stre"
export(String, "hp", "mp") var point_stat := "hp"

func get_text() -> String:
	return ("Pow: %d\nHit: %d\nTarget: %s\n" % [power, accuracy, target_type]) + description

func use(user: Node, targets: Array, _anim: bool) -> void:
	randomize()
	user.set(cost_type, user.get(cost_type)-cost)
	if user.panel:
		user.panel.update_content()
	var turns_used:= 0
	for i in range(len(targets)):
		var target = targets[i]
		var is_miss = is_miss(user, target)
		var is_crit = is_crit(user, target)
		var def: String = get_def_affinity(target)
		var off: int = get_off_affinity(user)
		var point_change = calculate_points(user, target, def, off, is_crit)
		target.targeted_skill_data = [point_change, is_miss, is_crit, def, PointLabel.text_types.POINT]
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
			user.set(point_stat, user.get(point_stat) + point_change)
			user.set(point_stat, min(user.get(point_stat), user.get("max_"+point_stat)))
			user.set(point_stat, max(user.get(point_stat), 0))
			if not user in targets:
				targets.append(user)
				user.targeted_skill_data = [point_change, false, is_crit, def, PointLabel.text_types.POINT]
			else:
				user.targeted_skill_data[0] += point_change
		else:
			target.set(point_stat, target.get(point_stat) + point_change)
			target.set(point_stat, min(target.get(point_stat), target.get("max_"+point_stat)))
			target.set(point_stat, max(target.get(point_stat), 0))
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

func is_crit(user: Node, target: Node) -> bool:
	if user.status == "sad": return false
	if not can_crit: return false
	return not rand_range(0,1) >= (critical + (user.luck - (target.luck/3.0)))/100.0

func calculate_points(user: Node, target: Node, def: String, off: int, is_crit: bool) -> int:
	var neg = power < 0
	var base = abs(power) + (user.level) + (5*user.get(stat))
	if def == "weak":
		base *= 1.75
	elif def == "resist":
		base *= 0.5
	elif def == "absorb":
		base *= -1
	elif def == "null":
		base *= 0
	if user.status == "sad":
		base *= 0.6
	if off < 0:
		base *= 2+(off/100.0)
	else:
		base *= off/100.0
	base *= 1.75 if is_crit else 1.0
	base *= -1 if neg else 1
	if user.focus and affinity == "phys":
		user.focus = false
		base *= 2.35
	if stat == "magi" or stat == "stre":
		var buff_stage = user.attack - target.defense
		var modifier := 1.0
		if buff_stage < 0:
			modifier /= 1+abs(buff_stage*0.26)
		else:
			modifier *= 1+abs(buff_stage*0.26)
		base *= modifier
	base *= rand_range(0.8,1.1)
	return int(base)
