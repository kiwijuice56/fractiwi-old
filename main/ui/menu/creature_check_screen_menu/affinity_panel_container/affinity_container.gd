extends Container
class_name AffinityContainer

export(NodePath) var label
export(NodePath) var hbox
export var panel: PackedScene

func _ready() -> void:
	label = get_node(label)
	hbox = get_node(hbox)

func set_affinities(type: String, affinities: Dictionary) -> void:
	label.text = type
	for child in hbox.get_children():
		hbox.remove_child(child)
		child.queue_free()
	for affinity in affinities.keys():
		var new_panel = panel.instance()
		new_panel.set_affinity(affinity, affinities[affinity])
		hbox.add_child(new_panel)
