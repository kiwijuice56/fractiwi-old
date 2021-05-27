extends ButtonPanel

export(NodePath) var time_label

var file: Resource

func _ready():
	time_label = get_node(time_label)
	set_time(3724)

func set_time(time: int) -> void:
	var hours = time/3600
	var minutes = (time-(hours*3600))/60
	var seconds = time-(hours*3600)-(minutes*60)
	time_label.text = "%02d:%02d:%02d" % [hours, minutes, seconds]
