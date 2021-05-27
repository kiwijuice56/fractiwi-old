extends ButtonPanel
class_name CreatureButtonPanel
# Maintains a CreatureButtonPanel's elements

export var active_style: Resource
export var name_label: NodePath
export var hp_bar: NodePath
export var mp_bar: NodePath
export var creature_icon: NodePath
export var status_icon: NodePath
export var in_party_indicator: NodePath
var creature: Creature 

func _ready() -> void:
	pass

func update_content() -> void:
	get_node(name_label).text = creature.name
	get_node(hp_bar).set_data("HP", creature.hp, creature.max_hp)
	get_node(mp_bar).set_data("MP", creature.mp, creature.max_mp)
	if creature.get_parent().name == "Active" and get_parent().name == "FullPartyContainer":
		get_node(in_party_indicator).visible = true
	else:
		get_node(in_party_indicator).visible = false
