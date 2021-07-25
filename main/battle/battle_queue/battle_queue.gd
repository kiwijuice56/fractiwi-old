extends Node
class_name BattleQueue
# Main loop for battle; cycles through all creatures

export (NodePath) var player_party_node
var expe := 0
var pointer := 0

func _ready() -> void:
	get_viewport().connect("battle_start", self, "battle")
	player_party_node = get_node(player_party_node)

func position_enemies() -> void:
	for i in range($EnemyParty.get_child_count()):
		$EnemyParty.get_child(i).position.x += i*64
# warning-ignore:integer_division
	$EnemyParty.position.x = 245 - ((($EnemyParty.get_child_count()-1)*64)/2)

func agility_sort(a: Creature, b: Creature) -> bool:
	return a.agil > b.agil

func initialize_parties(enemy_party: Array, player_party: Array) -> Node:
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
		creature.heal_points()
		creature.reset_buffs()
	position_enemies()
	for creature in player_party:
		player_party_node.get_node("Active").remove_child(creature)
		$PlayerParty.add_child(creature)
		creature.reset_buffs()
	player_party_node.get_node("Active").displaced = true
	
	# Get average agility
	var enemy_ag := 0.0
	var player_ag := 0.0
	for creature in enemy_party:
		enemy_ag += creature.agil
	for creature in player_party:
		player_ag += creature.agil
	player_ag /= $PlayerParty.get_child_count()
	enemy_ag /= $EnemyParty.get_child_count()
	if enemy_ag > player_ag:
		return $EnemyParty
	else:
		return $PlayerParty

func return_player_party(player_party: Array) -> void:
	player_party_node.get_node("Active").displaced = false
	for creature in player_party:
		creature.get_parent().remove_child(creature)
		player_party_node.get_node("Active").add_child(creature)

func to_array(party: Node, old_arr: Array) -> Array:
	var l_p = pointer-1
	var arr = party.get_children()
	arr.sort_custom(self, "agility_sort")
	if not len(old_arr) == 0:
		# if removed
		for i in range(len(old_arr)):
			if (not old_arr[i] in arr) and i <= l_p:
				pointer -= 1
		# if added:
		for i in range(len(arr)):
			if (not arr[i] in old_arr) and i <= l_p:
				pointer += 1
	return arr

func turn_logic(turns_used: int, full: int, half: int) -> Array:
	match turns_used:
			-2: # repels
				full = 0
				half = 0
			-1: # nullify, absorb
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
			8: # ran!
				full = 100
	return [full, half]


func battle(enemy_creatures: Array) -> void:
	yield(get_viewport().transition, "in_finished")
	expe = 0
	var player_creatures = player_party_node.get_node("Active").get_children()
	var current = initialize_parties(enemy_creatures, player_creatures)
	var opposite = $EnemyParty if current == $PlayerParty else $PlayerParty
	
	var current_array = to_array(current, [])
	var opposite_array = to_array(opposite, [])
	
	var full: int = current.get_child_count()
	for child in current.get_children():
		if child.is_boss:
			full += 1
	var half: int = 0
	var did_run := false
	pointer = 0
	yield(get_viewport().game, "battle_ready") # becaused called from battle_start signal, game may start before menu is initialized
	while $PlayerParty.get_child_count() > 0 and $EnemyParty.get_child_count() > 0:
		get_viewport().game.press_turn_container.set_side(current == $PlayerParty)
		get_viewport().game.press_turn_container.set_turns(full, half, true)
		
		get_viewport().game.update_party()
		
		current_array = to_array(current, current_array)
		opposite_array = to_array(opposite, [])
		
		if pointer >= len(current_array):
			pointer = 0
		
		
		# get turns used
		var turns: Array = turn_logic(yield(current_array[pointer].do_turn(current_array, opposite_array), "completed"), full, half)
		
		full = turns[0]
		half = turns[1]
		
		if full == 100:
			did_run = true
			break
		
		if full + half <= 0 and $PlayerParty.get_child_count() > 0 and $EnemyParty.get_child_count() > 0:
			#swap parties
			var temp = current
			current = opposite
			opposite = temp
			
			pointer = 0
			current_array = to_array(current, [])
			opposite_array = to_array(opposite, [])
			
			# initialize values
			full = current.get_child_count()
			for child in current.get_children():
				if child.is_boss:
					full += 1
			half = 0
			get_viewport().game.effect_handler.fade(get_viewport().game.press_turn_container, "hide", 0.25)
			yield(get_viewport().game.effect_handler, "complete")
			get_viewport().game.press_turn_container.set_turns(0, 0, false)
			get_viewport().game.effect_handler.fade(get_viewport().game.press_turn_container, "show", 0.25)
		else:
			pointer += 1
	if not did_run:
		for child in $PlayerParty.get_children():
			child.expe += expe
	return_player_party($PlayerParty.get_children())
	var function = get_viewport().party.check_level_ups()
	if function:
		yield(get_viewport().party, "level_up_complete")
	get_viewport().battle_ended(did_run)
	if did_run:
		yield(get_viewport().transition, "in_finished")
		for creature in $EnemyParty.get_children():
			creature.queue_free()
