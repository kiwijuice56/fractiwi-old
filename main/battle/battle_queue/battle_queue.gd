extends Node
class_name BattleQueue
# Main loop for battle; cycles through all creatures

export (NodePath) var player_party_node

func _ready() -> void:
	get_viewport().connect("battle_start", self, "battle")
	player_party_node = get_node(player_party_node)

func position_enemies() -> void:
	for i in range($EnemyParty.get_child_count()):
		$EnemyParty.get_child(i).position.x += i*48
	$EnemyParty.position.x = 280 - ((($EnemyParty.get_child_count()-1)*48)/2)

func agility_sort(a: Creature, b: Creature) -> bool:
	return a.agil > b.agil

func initialize_parties(enemy_party: Array, player_party: Array) -> Node:
	enemy_party.sort_custom(self, "agility_sort")
	player_party.sort_custom(self, "agility_sort")
	
	# Removing existing creatures
	for child in $PlayerParty.get_children():
		$PlayerParty.remove_child(child)
		child.queue_free()
	for child in $EnemyParty.get_children():
		$EnemyParty.remove_child(child)
		child.queue_free()
	
	# Add creatures to appropriate party node
	for creature in enemy_party:
		$EnemyParty.add_child(creature)
	position_enemies()
	for creature in player_party:
		player_party_node.get_node("Active").remove_child(creature)
		$PlayerParty.add_child(creature)
	player_party_node.get_node("Active").displaced = true
	# Return fastest party
	if $EnemyParty.get_child(0).agil < $PlayerParty.get_child(0).agil:
		return $PlayerParty
	else:
		return $EnemyParty

func turn_logic(turns_used: int, full: int, half: int) -> Array:
	match turns_used:
			-2: # drains, repels
				full = 0
				half = 0
			-1: # nullify
				for _i in range(2):
					if half > 0:
						half -= 1
					else:
						full -= 1
			0: # regular
				if half > 0:
					half -= 1
				else:
					full -= 1
			1: # pass
				if half == 0:
					half += 1
					full -= 1
				else:
					half -= 1
			2: # weakness, critical
				if full > 0:
					full -= 1
					half += 1
				else:
					half -= 1
	return [full, half]

func battle(enemy_creatures: Array) -> void:
	var player_creatures = player_party_node.get_node("Active").get_children()
	var current = initialize_parties(enemy_creatures, player_creatures)
	var opposite = $EnemyParty if current == $PlayerParty else $PlayerParty
	
	var full: int = current.get_child_count()
	var half: int = 0
	while $PlayerParty.get_child_count() > 0 and $EnemyParty.get_child_count() > 0:
		if current == $PlayerParty:
			get_viewport().game.enable(true)
		else:
			get_viewport().game.disable(true)
		get_viewport().game.press_turn_container.set_turns(full, half)
		var turns: Array = turn_logic(yield(current.get_child(0).do_turn(current, opposite), "completed"), full, half)
		full = turns[0]
		half = turns[1]
		if full + half <= 0:
			var temp = current
			current = opposite
			opposite = temp
			full = current.get_child_count()
			half = 0
			get_viewport().game.effect_handler.fade(get_viewport().game.press_turn_container, "hide", 0.25)
			yield(get_viewport().game.effect_handler, "complete")
			get_viewport().game.effect_handler.fade(get_viewport().game.press_turn_container, "show", 0.25)
		else:
			var front = current.get_child(0)
			current.remove_child(front)
			current.add_child(front)
