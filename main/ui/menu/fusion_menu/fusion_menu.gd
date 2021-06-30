extends UIController
class_name FusionMenu

export (NodePath) var level_label
export (NodePath) var prompt_label
export (NodePath) var creature_fusion
export (NodePath) var scene_animation
export var creature_button_panel: PackedScene

var ingredient1: Creature
var ingredient2: Creature
var party: Array
var results: Array

signal creature_chosen(creature)

func _ready() -> void:
	level_label = get_node(level_label)
	prompt_label = get_node(prompt_label)
	creature_fusion = get_node(creature_fusion)
	scene_animation = get_node(scene_animation)

func _input(event: InputEvent) -> void:
	if disabled: return
	if event.is_action_pressed("ui_cancel", false):
		if ingredient1:
			ingredient1 = null
			emit_signal("creature_chosen", null)
			return
		emit_signal("creature_chosen", null)
		main_viewport.transition.transition_in()
		._input(event)
		disable(true)
		yield(main_viewport.transition, "in_finished")
		disable(false)
		back.enable(true)
		main_viewport.transition.transition_out()
	if event.is_action_pressed("ui_accept", false) and state == "selecting":
		var suspected_ingredient = input["IngredientPanelContainer"].creatures[get_focus_owner().get_index()]
		if ingredient1 == suspected_ingredient or ((ingredient1 and suspected_ingredient) and not results[get_focus_owner().get_index()]):
			main_viewport.menu_sound_player.play_sound("Can't")
			return
		get_focus_owner().selected = true
		get_focus_owner().focus_entered()
		main_viewport.menu_sound_player.play_sound("Next")
		emit_signal("creature_chosen", suspected_ingredient)

func update_ingredients() -> void:
	party = main_viewport.party.get_node("Active").get_children() + main_viewport.party.get_node("Inactive").get_children()
	party.remove(party.find(main_viewport.party.get_node("Active/Yun")))
	input["IngredientPanelContainer"].creatures = party
	input["IngredientPanelContainer"].add_items()

func update_results() -> void:
	if ingredient1:
		results = []
		for member in party:
			results.append(creature_fusion.fuse(member, ingredient1))
		input["ResultPanelContainer"].creatures = results
		input["ResultPanelContainer"].add_items()
	else:
		input["ResultPanelContainer"].creatures = []
		input["ResultPanelContainer"].add_items()

func set_up(event: String) -> void:
	level_label.text = "lvl " + str(main_viewport.party.get_node("Active/Yun").level)
	match event:
		"fuse":
			var saved_index1 := 0
			var saved_index2 := 0
			while not (ingredient1 and ingredient2):
				update_results()
				var result: Creature
				if not ingredient1:
					input["IngredientPanelContainer"].grab_focus_at(saved_index1)
					input["IngredientPanelContainer"].get_child(saved_index1).focus_entered()
					prompt_label.text = "Select the first ingredient .."
					input["HotKeyContainer"].hotkeys = {"Confirm Ingredient": "ui_accept","Select Creature": "up_down"}
					input["HotKeyContainer"].add_items()
					ingredient1 = yield(select_creature(), "completed")
					if not ingredient1: # cancel selection entirely
						return
					saved_index1 = get_focus_owner().get_index()
					saved_index2 = saved_index1
				update_results()
				if not ingredient2:
					input["IngredientPanelContainer"].grab_focus_at(saved_index2)
					input["IngredientPanelContainer"].get_child(saved_index2).focus_entered()
					prompt_label.text = "Select the second ingredient .."
					input["HotKeyContainer"].hotkeys = {"Confirm Ingredient": "ui_accept","Select Creature": "up_down"}
					input["HotKeyContainer"].add_items()
					ingredient2 = yield(select_creature(), "completed")
					saved_index2 = get_focus_owner().get_index()
					if not ingredient2:
						input["IngredientPanelContainer"].get_child(saved_index1).selected = false
						continue
					result = results[get_focus_owner().get_index()]
				disable(true)
				state = "fusion_check_screen"
				main_viewport.transition.transition_in()
				yield(main_viewport.transition, "in_finished")
				disable(false)
				main_viewport.creature_check.back = self
				main_viewport.creature_check.enable(true)
				main_viewport.creature_check.open_fusion()
				main_viewport.creature_check.party = [result, ingredient1, ingredient2]
				var panel = creature_button_panel.instance()
				$CreatureButtonPanelContainer.add_child(panel)
				$CreatureButtonPanelContainer.add_child(result)
				panel.creature = result
				main_viewport.party.initialize_member(result)
				result.heal_points()
				panel.update_content()
				main_viewport.creature_check.index = 0
				main_viewport.creature_check.show_creature(result)
				main_viewport.transition.transition_out()
				var confirm = yield(main_viewport.creature_check, "fusion_confirmed")
				if not confirm:
					enable(true)
					ingredient2 = null
					input["IngredientPanelContainer"].get_child(saved_index2).selected = false
					panel.queue_free()
				else:
					main_viewport.creature_check.disable(true)
					disable(true)
					main_viewport.transition.transition_in()
					yield(main_viewport.transition, "in_finished")
					main_viewport.creature_check.disable(false)
					disable(false)
					ingredient1.get_parent().remove_child(ingredient1)
					ingredient2.get_parent().remove_child(ingredient2)
					panel.queue_free()
					$CreatureButtonPanelContainer.remove_child(result)
					main_viewport.party.get_node("Inactive").add_child(result)
					result.name = result.creature_name
					scene_animation.visible = true
					main_viewport.transition.transition_out()
					yield(scene_animation.animate(ingredient1, ingredient2, result), "completed")
					main_viewport.transition.transition_in()
					yield(main_viewport.transition, "in_finished")
					scene_animation.visible = false
					ingredient1.queue_free()
					ingredient2.queue_free()
					ingredient1 = null
					ingredient2 = null
					update_ingredients()
					saved_index1 = 0
					saved_index2 = 0
					main_viewport.game.update_party()
					main_viewport.transition.transition_out()
					enable(true)
					continue
		"banish":
			prompt_label.text = "Select a creature to banish .."

func select_creature() -> Creature:
	set_process_input(true)
	state = "selecting"
	var creature = yield(self, "creature_chosen")
	state = "default"
	return creature

func disable(show: bool) -> void:
	.disable(show)
	set_process_input(false)

func enable(show: bool) -> void:
	.enable(show)
	set_process_input(true)
