tool
extends Node
class_name FusionCataloger
 # Script that creates tables for fusion; code is slow but will never run in-game

export var creature_path: String = "res://main/battle/creature/"
var races := ["Human", "Object", "Beast", "Spirit", "Demon", "Angel", "Plant", "Element"]

var max_level := 255
var creature_matrix: Array
var race_matrix: Array

func _ready() -> void:
	pass
	# WARNING - uncommenting this will overwrite fusion tables permenantly
#	update_creature_matrix()
#	update_race_matrix()
#	get_node("../FusionCatalogue").creature_matrix = creature_matrix
#	get_node("../FusionCatalogue").race_matrix = race_matrix

func update_creature_matrix() -> void:
	creature_matrix = []
	for race in races:
		var empty_array = []
		for _i in range(0, max_level):
			empty_array.append("")
		creature_matrix.append(empty_array)
	var creatures := get_all_creatures()
	for creature in creatures:
		var race_index = races.find(creature.race)
		for i in range(0, creature.level):
			if not creature_matrix[race_index][i]:
				creature_matrix[race_index][i] = creature.creature_name

func update_race_matrix() -> void:
	race_matrix = []
	for i in range(len(races)):
		race_matrix.append([])
		for _j in range(len(races)):
			race_matrix[i].append("Special")
	for i in range(len(races)-1):
		for j in range(i):
			var race_index = randi() % len(races)-1
			while race_index == i or race_index == j:
				race_index = randi() % len(races)-1
			var race: String = races[race_index] 
			race_matrix[i][j] = race
			race_matrix[j][i] = race
		race_matrix[i][i] = "Element"

func get_all_creatures() -> Array:
	var creatures := []
	var dir := Directory.new()
	dir.open(creature_path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var creature_scene_path = creature_path + file_name + ("/%s.tscn" % file_name.capitalize()) 
		if dir.file_exists(creature_scene_path):
			var creature = load(creature_scene_path).instance()
			creatures.append(creature)
		file_name = dir.get_next()
	return creatures
