extends ButtonPanel
class_name SkillButtonPanel

export(NodePath) var icon
export(NodePath) var name_label
export(NodePath) var cost_label1
export(NodePath) var cost_label2
export var disabled_modulate: Color
export var mp_color1: Color
export var mp_color2: Color
export var hp_color1: Color
export var hp_color2: Color

var skill

func _ready() -> void:
	icon = get_node(icon)
	name_label = get_node(name_label)
	cost_label1 = get_node(cost_label1)
	cost_label2 = get_node(cost_label2)
	connect("focus_entered", self, "update_description")

func update_description() -> void:
	get_viewport().game.skill_description_label.text = skill.get_text()

func set_disabled(val: bool) -> void:
	.set_disabled(val)
	if disabled:
		$HBoxContainer.modulate = disabled_modulate
	else:
		$HBoxContainer.modulate = Color(1,1,1)

func set_content(given_skill: Skill) -> void:
	skill = given_skill
	name_label.text = skill.name
	if "cost_type" in skill:
		cost_label1.text = str(skill.cost)
		cost_label2.text = skill.cost_type
		if skill.cost_type == "hp":
			cost_label1.set("custom_colors/font_color", hp_color1)
			cost_label2.set("custom_colors/font_color", hp_color2)
		elif skill.cost_type == "mp":
			cost_label1.set("custom_colors/font_color", mp_color1)
			cost_label2.set("custom_colors/font_color", mp_color2)
	else:
		cost_label1.text = ""
		cost_label2.text = ""
	icon.set_icon(skill.affinity)
