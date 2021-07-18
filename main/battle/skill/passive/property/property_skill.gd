extends PassiveSkill
class_name PropertySkill

export(String, "item_use") var property := "item_use"

func modify_creature(creature) -> void:
	creature.set(property, true)

func unmodify_creature(creature) -> void:
	creature.set(property, false)
