extends Node
class_name FileSaver
# Handles saving game to file

export var path: String
export var default_path: String

#func _ready():
#	save_file(0)

func get_files() -> Array:
	var files := []
	for _i in range(99):
		files.append(null)
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files[int(file.substr(0,2))] = load(path+file)
	dir.list_dir_end()
	return files

func save_file(index: int) -> void:
	var file = SaveFile.new()
	for node in get_tree().get_nodes_in_group("Save"):
		file.data[node.name] = node.save_data()
	var dir = Directory.new()
	dir.remove(path + "%02d.tres" % index)
	ResourceSaver.save(path + "%02d.tres" % index, file)

func load_file(index: int) -> void:
	var file
	if index == -1:
		file = load(default_path)
	else:
		file = load(path + "%02d.tres" % (index)) 
	for node in get_tree().get_nodes_in_group("Save"):
		node.load_data(file.data[node.name])

func load_data(data: Dictionary) -> void:
	$GameTime.time = data["time"]
	$GameTime.start()

func save_data() -> Dictionary:
	return {"time": $GameTime.time}
