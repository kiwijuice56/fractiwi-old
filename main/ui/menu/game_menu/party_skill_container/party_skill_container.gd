extends InputContainer
class_name PartySkillContainer
# Contains tabs with ButtonContainers that show skills for each creature

export var skill_button_container: PackedScene

func add_items() -> void:
	for container in get_children():
		controller.input.erase(container.name)
		remove_child(container)
		container.queue_free()
	for creature in controller.active_party.get_children():
		var container = skill_button_container.instance()
		container.name = creature.name
		container.controller = controller.get_path()
		add_child(container)
		container.button_names = creature.get_node("Skills").get_skill_names("Active")
		container.add_items()
