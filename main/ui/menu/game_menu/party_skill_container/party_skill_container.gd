extends InputContainer
class_name PartySkillContainer
# Contains tabs with ButtonContainers that show skills for each creature

export var skill_button_container: PackedScene
var mem_tab := 0

func _input(event: InputEvent) -> void:
	if not get("tabs_visible"):
		return
	var tab = get("current_tab")
	if event.is_action_pressed("ui_right", false):
		tab += 1
	if event.is_action_pressed("ui_left", false):
		tab -= 1
	if tab == -1:
		tab = get_child_count()-1
	if tab == get_child_count():
		tab = 0
	if get("current_tab") == tab:
		return
	controller.creature = controller.party.get_node("Active").get_node(get_child(tab).name)
	get_child(get("current_tab")).disable_input()
	get_child(tab).enable_input()
	setting_disable(get_child(tab))
	get_child(tab).grab_focus_at(0)
	set("current_tab", tab)

func setting_disable(container: SkillButtonContainer) -> void:
	if controller.in_battle:
		container.disable_battle()
	else:
		container.disable_overworld()

func add_items() -> void:
	mem_tab = get("current_tab")
	for container in get_children():
		controller.input.erase(container.name)
		remove_child(container)
		container.queue_free()
	for creature in controller.party.get_node("Active").get_children():
		var container = skill_button_container.instance()
		container.name = creature.creature_name
		container.controller = controller.get_path()
		add_child(container)
		container.creature = creature
		container.add_items()
		container.disable_input()
	for container in get_children():
		setting_disable(container)
	if not get_child_count() <= mem_tab:
		set("current_tab", mem_tab)

