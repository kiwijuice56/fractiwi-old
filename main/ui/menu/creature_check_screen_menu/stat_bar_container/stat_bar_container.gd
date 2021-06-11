extends ButtonContainer
class_name StatBarContainer

var stats = ["stre", "magi", "vita", "agil", "luck"]

func update_all(creature: Creature) -> void:
	for child in get_children():
		child.set_stat(creature)

func intialize_button(bar: Control, index: int ) -> void:
	bar.stat = stats[index]
	bar.connect("pressed", controller, "stat_increase", [bar.stat])

func add_items() -> void:
	button_count = len(stats)
	.add_items()
