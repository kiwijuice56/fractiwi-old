extends CanvasLayer
class_name PointLabel

func set_point_text(points: int, is_miss: bool, is_crit: bool, def: String) -> void:
	offset = get_parent().get_global_transform_with_canvas().get_origin()
	if "rect_size" in get_parent():
		offset += get_parent().rect_size/2
	if is_miss:
		$Label.text = "Miss"
		return
	if def == "repel":
		$Label.text = "Repel"
		return
	if def == "null":
		$Label.text = "Null"
		return
	$Label.text = str(points)
	if def == "weak":
		$Label.text += " weak"
	if is_crit:
		$Label.text += " crit"
