extends Button
class_name StatBar

export(NodePath) var texture_progress
export(NodePath) var stat_name
export var stat: String

func _ready() -> void:
	texture_progress = get_node(texture_progress)
	stat_name = get_node(stat_name)

func set_stat(creature: Creature) -> void:
	texture_progress.value = creature.get(stat)
	stat_name.text = stat + ": " + str(creature.get(stat))
