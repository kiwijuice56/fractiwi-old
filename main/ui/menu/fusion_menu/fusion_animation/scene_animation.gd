extends Node2D
class_name SceneAnimation
#tool
#
#func _ready():
#	yield(animate(null, null, null), "completed")
#	_ready()

func animate(creature1: Creature, creature2: Creature, creature3: Creature) -> void:
	if creature1: $CreatureSprite1.texture = creature1.texture
	if creature2: $CreatureSprite2.texture = creature2.texture
	if creature3: $CreatureSprite3.texture = creature3.texture
	$CreatureSprite1.modulate = Color(1,1,1,1)
	$CreatureSprite2.modulate = Color(1,1,1,1)
	$CreatureSprite3.modulate = Color(1,1,1,0)
	$Timer.start()
	yield($Timer, "timeout")
	$CreatureSprite1/AnimationPlayer.current_animation = "dissolve"
	$CreatureSprite2/AnimationPlayer.current_animation = "dissolve"
	yield($CreatureSprite1/AnimationPlayer, "animation_finished")
	$CreatureSprite3/AnimationPlayer.current_animation = "create"
	yield($CreatureSprite3/AnimationPlayer, "animation_finished")
	$Timer.start()
	yield($Timer, "timeout")
