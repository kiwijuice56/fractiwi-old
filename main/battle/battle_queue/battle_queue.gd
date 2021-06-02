extends Node
class_name BattleQueue

export (NodePath) var player_party

func _ready() -> void:
	get_viewport().connect("battle_start", self, "battle_started")
	player_party = get_node(player_party)

func agility_sort(a: Creature, b: Creature) -> bool:
	return a.agil > b.agil

func battle_started(creatures: Array) -> void:
	var enemy_party := []
	for creature in creatures:
		enemy_party.append(creature.instance())
	enemy_party.sort_custom(self, "agility_sort")
	for creature in enemy_party:
		$EnemyParty.add_child(creature)
	for creature in player_party.get_node("Active").get_children():
		player_party.get_node("Active").remove_child(creature)
		$PlayerParty.add_child(creature)
