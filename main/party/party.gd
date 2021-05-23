extends Node

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
