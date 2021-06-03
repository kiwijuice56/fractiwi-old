extends Node
class_name BattleQueue
# Main loop for battle; cycles through all creatures

export (NodePath) var player_party_node

func _ready() -> void:
	get_viewport().connect("battle_start", self, "battle")
	player_party_node = get_node(player_party_node)

func agility_sort(a: Creature, b: Creature) -> bool:
	return a.agil > b.agil

func initialize_parties(enemy_party: Array, player_party: Array) -> Node:
	enemy_party.sort_custom(self, "agility_sort")
	player_party.sort_custom(self, "agility_sort")
	
	# Add creatures to appropriate party node
	for creature in enemy_party:
		$EnemyParty.add_child(creature)
		player_party_node.get_node("Active").displaced = true
	for creature in player_party:
		player_party_node.get_node("Active").remove_child(creature)
		$PlayerParty.add_child(creature)
	
	# Return fastest party
	if $EnemyParty.get_child(0).agil < $PlayerParty.get_child(0).agil:
		return $PlayerParty
	else:
		return $EnemyParty

func battle(enemy_creatures: Array) -> void:
	var player_creatures = player_party_node.get_node("Active").get_children()
	var current = initialize_parties(enemy_creatures, player_creatures)
	var opposite = $EnemyParty if current == $PlayerParty else $PlayerParty
	while $PlayerParty.get_child_count() > 0 and $EnemyParty.get_child_count() > 0:
		var turns: int = current.get_child_count()*2
		turns -= yield(current.get_child(0).do_turn(current, opposite), "completed")
		if turns <= 0:
			var temp = current
			current = opposite
			opposite = temp
		else:
			var front = current.remove_child(0)
			current.add_child(front)
