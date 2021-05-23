extends Node
class_name Creature
# Contains data for a creature and functions to edit them

export(String, "Demon", "Human", "Inanimate", "Beast") var race: String = "Human"
export var level: int setget set_level
export var hp_growth: int
export var mp_growth: int
export var strength: int
export var magic: int
export var vitality: int
export var luck: int
export var agility: int

var hp: int = 3
var max_hp: int = 10
var mp: int
var max_mp: int

func set_level(new_level):
	level = new_level
	max_hp = hp_growth * level
	max_mp = mp_growth * level