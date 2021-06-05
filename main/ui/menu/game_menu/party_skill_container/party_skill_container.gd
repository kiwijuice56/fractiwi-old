extends InputContainer
class_name PartySkillContainer
# Contains tabs with ButtonContainers that show skills for each creature

export var skill_button_container: PackedScene

func _input(event: InputEvent) -> void:
	if not get("tabs_visible"):
		return
	var tab = get("current_tab")
	if event.is_action_pressed("ui_right") and !event.is_echo():
		tab += 1
	if event.is_action_pressed("ui_left") and !event.is_echo():
		tab -= 1
	if get("current_tab") == tab:
		return
	if tab == -1:
		tab = get_child_count()-1
	if tab == get_child_count():
		tab = 0
	get_child(tab).grab_focus_at(0)
	set("current_tab", tab)
	controller.creature = controller.party.get_node("Active").get_node(get_child(tab).name)
	print(controller.creature.name)

func add_items() -> void:
	for container in get_children():
		controller.input.erase(container.name)
		remove_child(container)
		container.queue_free()
	for creature in controller.party.get_node("Active").get_children():
		var container = skill_button_container.instance()
		container.name = creature.name
		container.controller = controller.get_path()
		add_child(container)
		container.button_names = creature.get_node("Skills").get_skill_names("Active")
		container.add_items()
