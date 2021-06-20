extends Node
class_name Party
# Contains functions to allow other nodes to modify party

signal level_up_complete

export var creature_path: String
export var player_ai: Script

func instance_member(creature: String, data: Dictionary) -> Creature:
	creature = creature.substr(2) # remove party order
	var scene = load( creature_path + ("%s/%s.tscn" % [creature.to_lower(), creature])).instance()
	scene.is_tamed = true
	scene.set_stats(data["stats"])
	scene.get_node("Skills").set_skills(data["skills"])
	if not scene is PlayerCreature: #player is set by items.gd .. efffects hold their own skills
		scene.get_node("UnlearnedSkills").set_skills(data["skills"])
	scene.get_node("AI").set_script(player_ai)
	return scene

func add_member(creature: Creature) -> void:
	if $Active.get_child_count() >= 4:
		$Inactive.add_child(creature)
	else:
		$Active.add_child(creature)

func delete_all() -> void:
	for child in $Inactive.get_children():
		delete(child, $Inactive)
	for child in $Active.get_children():
		delete(child, $Active)

func delete(creature: Creature, subset: Node) -> void:
	subset.remove_child(creature)
	creature.queue_free()

func in_active_party(creature: Creature) -> bool:
	return creature in $Active.get_children()

func summon_member(creature: Creature) -> bool:
	if $Active.get_child_count() >= 4 or creature.status == "dead":
		return false
	$Inactive.remove_child(creature)
	$Active.add_child(creature)
	return true

func return_member(creature: Creature) -> bool:
	if creature.name == "Yun":
		return false
	$Active.remove_child(creature)
	$Inactive.add_child(creature)
	return true

func check_level_ups() -> void:
	for child in $Active.get_children():
		var level_info: Array = child.set_level()
		var levels_changed = level_info[0]
		var skills_learned = level_info[1]
		if levels_changed > 0:
			get_viewport().transition.transition_in()
			yield(get_viewport().transition, "in_finished")
			if get_viewport().creature_check.state == "next":
				yield(get_viewport().creature_check, "ready_for_next")
			get_viewport().transition.transition_out()
			get_viewport().creature_check.level_up(child, levels_changed, skills_learned)
			yield(get_viewport().creature_check, "level_finished")
	emit_signal("level_up_complete")

func save_data() -> Dictionary:
	var active = {}
	for i in range($Active.get_child_count()):
		active[("%02d"%i)+$Active.get_child(i).name] = $Active.get_child(i).to_dict()
	var inactive = {}
	for i in range($Inactive.get_child_count()):
		inactive[("%02d"%i)+$Inactive.get_child(i).name]  = $Inactive.get_child(i).to_dict()
	return {"active": active, "inactive": inactive}

func load_data(data: Dictionary) -> void:
	delete_all()
	for creature_name in data["inactive"].keys():
		$Inactive.add_child(instance_member(creature_name, data["inactive"][creature_name]))
	for creature_name in data["active"].keys():
		$Active.add_child(instance_member(creature_name, data["active"][creature_name]))
