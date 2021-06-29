extends PanelContainer
class_name UnlearnedSkillContainer

export var skill_panel: PackedScene

func initialize(creature: Creature) -> void:
	var to_delete := []
	for i in range(1, $VBoxContainer.get_child_count()):
		var child = $VBoxContainer.get_child(i)
		to_delete.append(child)
	for child in to_delete:
		$VBoxContainer.remove_child(child)
		child.queue_free()
	if creature.get_node("UnlearnedSkills").get_child_count() > 0:
		for skill in creature.get_node("UnlearnedSkills").get_children():
			var new_panel = skill_panel.instance()
			$VBoxContainer.add_child(new_panel)
			new_panel.set_content(skill)
