extends ButtonPanel
class_name UISaveFile

export(NodePath) var time_label

var file: Resource

func set_time(time: int) -> void:
	#warning-ignore:integer_division
	var hours = int(time/3600)
	var minutes = (time-(hours*3600))/60
	var seconds = time-(hours*3600)-(minutes*60)
	time_label.text = "%02d:%02d:%02d" % [hours, minutes, seconds]
