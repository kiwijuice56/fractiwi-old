extends Interactable
class_name Bed

export(NodePath) var room

func _ready() -> void:
	room = get_node(room)

func interacted() -> void:
	yield(enter_bed(true), "completed")
	heal_party()
	enter_save_screen()

func finish_interaction() -> void:
	player.visible = true
	$Sprite.frame = 1
	if player.global_position.x > global_position.x:
		player.face_direction("right")
	else:
		player.face_direction("left")
	yield(player.tween_sprite(player.global_position, 0.3), "completed")
	state = "Enter bed"
	get_viewport().interact.disable(true)
	player.can_move = true
	player.set_physics_process(true)
	body_entered(player)
	get_viewport().game.can_open = true

func enter_bed(anim: bool) -> void:
	player.set_physics_process(false)
	player.can_move = false
	if player.global_position.x > global_position.x:
		player.face_direction("left")
	else:
		player.face_direction("right")
	state = "saving"
	get_viewport().game.can_open = false
	get_viewport().interact.disable(true)
	if anim:
		yield(player.tween_sprite(global_position, 0.3), "completed")
	else:
		player.tween_sprite(global_position, 0)
	$Sprite.frame = 0
	player.visible = false
	if anim:
		$AnimationPlayer.current_animation = "bed_sequence"
		yield($AnimationPlayer, "animation_finished")

func enter_save_screen() -> void:
	room.current_terminal = name
	get_viewport().transition.transition_in_heavy()
	get_viewport().game.disable(false)
	get_viewport().world_node.player.can_move = false
	get_viewport().world_node.pause()
	yield(get_viewport().transition, "in_finished")
	get_viewport().terminal.enable(true)
	get_viewport().interact.disable(false)
	get_viewport().transition.transition_out_heavy()

func heal_party() -> void:
	for node in get_viewport().party.get_node("Active").get_children():
		node.heal_points()
		node.status = "ok"
		if node.panel:
			node.panel.update_content()
	for node in get_viewport().party.get_node("Inactive").get_children():
		node.status = "ok"
		node.heal_points()
		if node.panel:
			node.panel.update_content()

func body_entered(given_player: KinematicBody2D) -> void:
	if state != "Enter bed":
		return
	player = given_player
	player.main_viewport.interact.current_interactable = self
	player.main_viewport.interact.state = state
	player.main_viewport.interact.enable(true)
