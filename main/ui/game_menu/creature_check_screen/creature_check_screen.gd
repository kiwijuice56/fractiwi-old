extends UIController

export(NodePath) var off_affinity
export(NodePath) var def_affinity

var creature: Creature

func _ready() -> void:
	def_affinity = get_node(def_affinity)
	off_affinity = get_node(off_affinity)

func set_affinities() -> void:
	pass
	#off_affinity.set_affinity_panels(creature.off_affinity)
	#def_affinity.set_affinity_panels(creature.def_affinity)
