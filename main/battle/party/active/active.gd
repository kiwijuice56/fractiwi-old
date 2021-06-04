extends Node2D
class_name ActiveParty
# Contains all active player party members
# When battle starts, all are displaced to BattleQueue/PlayerParty
# This script redirects attempts to get children to this node

export (NodePath) var battle_party_node
var displaced := false

func _ready() -> void:
	battle_party_node = get_node(battle_party_node)

func get_children():
	if displaced:
		return battle_party_node.get_children()
	return .get_children()

func add_child(node: Node, legible: bool = false):
	if displaced:
		battle_party_node.add_child(node, legible)
	else:
		.add_child(node, legible)

func remove_child(node: Node, legible: bool = false):
	if displaced:
		battle_party_node.remove_child(node)
	else:
		.remove_child(node)
