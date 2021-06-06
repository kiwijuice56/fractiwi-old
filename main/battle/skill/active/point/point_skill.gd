extends ActiveSkill
class_name PointSkill

export(int, -100, 100) var power := 0

func use(user: Creature, targets: Array, anim: bool) -> void:
	for target in targets:
		var is_miss = is_miss(user, target)
		var def_affinity: int = get_def_affinity(target)
		var off_affinity: int = get_off_affinity(target)
		var point_change = calculate_points(user, target, def_affinity, off_affinity)
		if not is_miss: target.hp += point_change
		target.targeted_skill_data = [affinity, is_miss, def_affinity, off_affinity]
	var effect: ActiveSkillEffect = effect_packed.instance()
	var last_effect: ActiveSkillEffect = effect
	var place_timer = Timer.new()
	add_child(place_timer)
	match effect.count:
		"single":
			pass
		"multiple":
			for target in targets:
				var new_effect := effect.duplicate()
				add_child(new_effect)
				new_effect.start(target.global_position, [target])
				last_effect = new_effect
				place_timer.start(effect.delay)
				yield(place_timer, "timeout")
	yield(last_effect, "tree_exited")
	remove_child(place_timer)
	place_timer.queue_free()
	return 0

func is_miss(user: Creature, target: Creature) -> bool:
	return false

func calculate_points(user: Creature, target: Creature, def_mult: int, off_mult: int) -> int:
	return 1

func get_def_affinity(target: Creature) -> int:
	return 100

func get_off_affinity(user: Creature) -> int:
	return 100
