extends Node
class_name Selector

export(NodePath) var controller
var index := 0
var current_target_type := ""
var current_side := ""

signal selection_complete

func _ready() -> void:
	controller = get_node(controller)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel", false):
		set_process_input(false)
		emit_signal("selection_complete", false)
		return
	if event.is_action_pressed("ui_accept", false):
		set_process_input(false)
		emit_signal("selection_complete", true)
		return
	
	if current_target_type == "all":
		return
	
	var old_index: int = index
	if event.is_action_pressed("ui_right", false):
		index += 1
	if event.is_action_pressed("ui_left", false):
		index -= 1
	if index == old_index: return
	match current_side:
		"opposite":
			var enemies: Array = controller.enemy_party.get_children()
			if index >= len(enemies):
				index = 0
			elif index < 0:
				index = len(enemies)-1
			enemies[old_index].get_node("AnimationPlayer").current_animation = "deselected"
			enemies[index].get_node("AnimationPlayer").current_animation = "selected"
		"same":
			pass

func select(target_type: String, side: String) -> Array:
	set_process_input(true)
	index = 0
	current_side = side
	current_target_type = target_type
	match side:
		"opposite":
			var enemies: Array = controller.enemy_party.get_children()
			match target_type:
				"single":
					enemies[0].get_node("AnimationPlayer").current_animation = "selected"
					var success: bool = yield(self, "selection_complete")
					enemies[index].get_node("AnimationPlayer").current_animation = "deselected"
					if not success:
						return []
					return [enemies[index]]
				"all":
					for enemy in enemies:
						enemy.get_node("AnimationPlayer").current_animation = "selected"
					var success: bool = yield(self, "selection_complete")
					for enemy in enemies:
						enemy.get_node("AnimationPlayer").current_animation = "deselected"
					if not success:
						return []
					return enemies
		"same":
			match target_type:
				"single":
					pass
				"all":
					yield(self, "selection_complete")
					return controller.party.get_node("Active").get_children()
	return []

func select_enemy() -> void:
	pass
