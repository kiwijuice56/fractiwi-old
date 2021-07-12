extends ButtonPanel
class_name ItemButtonPanel

export(NodePath) var icon
export(NodePath) var name_label
export(NodePath) var count_label
export var disabled_modulate: Color

var skill

func _ready() -> void:
	icon = get_node(icon)
	name_label = get_node(name_label)
	count_label = get_node(count_label)
	connect("focus_entered", self, "update_description")

func update_description() -> void:
	get_viewport().game.item_description_label.text = skill.get_text()

func set_disabled(val: bool) -> void:
	.set_disabled(val)
	if disabled:
		$HBoxContainer.modulate = disabled_modulate
	else:
		$HBoxContainer.modulate = Color(1,1,1)

func set_content(given_skill: Skill, count: int) -> void:
	skill = given_skill
	name_label.text = skill.name
	icon.set_icon(skill.affinity)
	count_label.text = "x" + str(count)
