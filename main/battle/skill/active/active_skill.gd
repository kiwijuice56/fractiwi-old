extends Skill
class_name ActiveSkill

export var effect: PackedScene 
export(String, "phys", "fire", "ice", "elec", "wind", "light", "death", "mind", "flesh") var affinity := "phys"
export(String, "all", "single", "random") var target_type := "single"
export(String, "opposite", "same") var side := "opposite"
export(int, 0, 100) var accuracy := 0
