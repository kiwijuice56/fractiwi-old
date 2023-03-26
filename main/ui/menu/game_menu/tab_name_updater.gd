extends Node

onready var container := get_parent().get_node("PartySkillContainer")

func _ready() -> void:
	container.connect("update_tab_names", self, "update")

func update() -> void:
	for i in range(container.get_child_count()):
		container.set_tab_title(i, container.get_tab_title(i).substr(0, 3))
