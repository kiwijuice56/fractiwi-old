extends ButtonPanel
class_name CreatureButtonPanel
# Maintains a CreatureButtonPanel's elements

export var active_style: Resource
export(NodePath) var name_label
export(NodePath) var hp_bar
export(NodePath) var mp_bar
export(NodePath) var creature_icon
export(NodePath) var status_icon
export(NodePath) var in_party_indicator
export var icons: Dictionary
var creature: Creature setget set_creature
var focus_style_lock: bool


func _ready() -> void:
	name_label = get_node(name_label)
	mp_bar = get_node(mp_bar)
	hp_bar = get_node(hp_bar)
	status_icon = get_node(status_icon)
	in_party_indicator = get_node(in_party_indicator)

func set_creature(new_creature: Creature) -> void:
	creature = new_creature
	creature.panel = self

func focus_entered() -> void:
	if focus_style_lock: return
	.focus_entered()

func focus_exited() -> void:
	if focus_style_lock: return
	.focus_exited()

func update_content() -> void:
	name_label.text = creature.name
	hp_bar.set_data("HP", creature.hp, creature.max_hp)
	mp_bar.set_data("MP", creature.mp, creature.max_mp)
	set_status_icon(creature.status)
	if (creature.get_parent().name == "Active" or creature.get_parent().name == "PlayerParty")and get_parent().name == "FullPartyContainer":
		in_party_indicator.visible = true
	else:
		in_party_indicator.visible = false

func set_status_icon(status: String) -> void:
	status_icon.texture = icons[status]
	if status == "dead":
		self.disabled = true
	else:
		self.disabled = false
