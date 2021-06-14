extends PanelContainer
class_name UnlearnedSkillContainer

export var skill_panel: PackedScene

func initialize(creature: Creature) -> void:
	if len($VBoxContainer.get_children()) > 1:
		$VBoxContainer.remove_child($VBoxContainer.get_child(1))
	if creature.get_node("UnlearnedSkills").get_child_count() > 0:
		var new_panel = skill_panel.instance()
		$VBoxContainer.add_child(new_panel)
		new_panel.set_content(creature.get_node("UnlearnedSkills").get_child(0))
