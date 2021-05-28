extends Node

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
	if $Active.get_child_count() >= 4:
		return false
	$Inactive.remove_child(creature)
	$Active.add_child(creature)
	return true

func return_member(creature: Creature) -> bool:
	if creature.get_index() == 0:
		return false
	$Active.remove_child(creature)
	$Inactive.add_child(creature)
	return true
