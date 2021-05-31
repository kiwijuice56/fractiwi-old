extends ButtonPanel
class_name SaveFile

export(NodePath) var location_label
export(NodePath) var empty_label
export(NodePath) var num_label
export(NodePath) var time_label

func _ready():
	location_label = get_node(location_label)
	empty_label = get_node(empty_label)
	num_label = get_node(num_label)
	time_label = get_node(time_label)

func initialize(path: String, index: int) -> void:
	if len(path) == 0:
		empty_label.text = "%02d EMPTY" % (index)
		$VBoxContainer.visible = false
		$EmptyLabel.visible = true
		return
	else:
		var file = File.new()
		file.open(path, File.READ)
		var data = parse_json(file.get_line())
		set_time(int(data["time"]))
		num_label.text = "%02d" % int(data["id"])
		file.get_line()
		location_label.text = parse_json(file.get_line())["location"]
		file.close()
		$VBoxContainer.visible = true
		$EmptyLabel.visible = false

func set_time(time: int) -> void:
	#warning-ignore:integer_division
	var hours = int(time/3600)
	var minutes = (time-(hours*3600))/60
	var seconds = time-(hours*3600)-(minutes*60)
	time_label.text = "%02d:%02d:%02d" % [hours, minutes, seconds]
