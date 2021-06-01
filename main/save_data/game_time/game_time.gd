extends Node

var time := 0

func _ready():
	$Timer.connect("timeout", self, "time_changed")

func start() -> void:
	$Timer.start()

func time_changed() -> void:
	time += 1
