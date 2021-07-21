extends Node
class_name CreatureFusion

export var creature_path: String

func fuse(ingredient1: Creature, ingredient2: Creature) -> Creature:
	var race_index1: int = $FusionCatalogue.races.find(ingredient1.race)
	var race_index2: int = $FusionCatalogue.races.find(ingredient2.race)
	var new_race: String = $FusionCatalogue.race_matrix[race_index1][race_index2]
	var new_race_index: int = 0
	if new_race == "Special":
		pass
	else:
		new_race_index = $FusionCatalogue.races.find(new_race)
	# warning-ignore:integer_division
	var avg_level = (ingredient1.base_level + ingredient2.base_level)/2
	print(ingredient1.name, " ", ingredient2.name, " ", avg_level)
	var creature_name: String = $FusionCatalogue.creature_matrix[new_race_index][avg_level-1]
	if creature_name:
		var creature = load(creature_path + ("%s/%s.tscn" % [creature_name.to_lower(), creature_name])).instance()
		return creature
	else:
		return null
