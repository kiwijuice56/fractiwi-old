extends ButtonPanel
class_name SkillButtonPanel

export(NodePath) var icon
export(NodePath) var name_label
export(NodePath) var cost_label

func _ready() -> void:
	icon = get_node(icon)
	name_label = get_node(name_label)
	cost_label = get_node(cost_label)

func set_content(skill: Skill) -> void:
	name_label.text = skill.name
	if "cost_type" in skill:
		cost_label.text = str(skill.cost) + " " + skill.cost_type 
