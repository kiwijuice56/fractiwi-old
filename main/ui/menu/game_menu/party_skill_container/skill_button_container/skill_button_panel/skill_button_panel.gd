extends ButtonPanel
class_name SkillButtonPanel

export(NodePath) var icon
export(NodePath) var name_label
export(NodePath) var cost_label
export var disabled_modulate: Color

var skill

func _ready() -> void:
	icon = get_node(icon)
	name_label = get_node(name_label)
	cost_label = get_node(cost_label)
	connect("focus_entered", self, "update_description")

func update_description() -> void:
	get_viewport().game.skill_description_label.text = skill.get_text()

func set_disabled(val: bool) -> void:
	.set_disabled(val)
	if disabled:
		modulate = disabled_modulate
	else:
		modulate = Color(1,1,1)

func set_content(given_skill: Skill) -> void:
	skill = given_skill
	name_label.text = skill.name
	if "cost_type" in skill:
		cost_label.text = str(skill.cost) + " " + skill.cost_type
	else:
		cost_label.text = ""
	icon.set_icon(skill.affinity)
