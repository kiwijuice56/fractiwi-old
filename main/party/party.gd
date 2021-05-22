extends Node

func return_creature(creature: Creature) -> bool:
	if not creature in $Active.get_children() or creature.get_index() == 0:
		return false
	$Active.remove_child(creature)
	$Inactive.add_child(creature)
	return true
