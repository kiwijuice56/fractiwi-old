extends CanvasLayer
class_name PointLabel

export var miss: Color
export var repel: Color
export var nullc: Color
export var absorb: Color
export var weak: Color
export var crit: Color

func set_point_text(points: int, is_miss: bool, is_crit: bool, def: String) -> void:
	offset = get_parent().get_global_transform_with_canvas().get_origin()
	$Label.add_color_override("font_color", Color(1,1,1))
	if "rect_size" in get_parent():
		offset += get_parent().rect_size/2
	if is_miss:
		$Label.text = "Miss"
		$Label.add_color_override("font_color", miss)
		return
	if def == "repel":
		$Label.text = "Repel"
		$Label.add_color_override("font_color", repel)
		return
	if def == "null":
		$Label.text = "Null"
		$Label.add_color_override("font_color", nullc)
		return
	$Label.text = str(points)
	if is_crit:
		$Label.text += " crit"
		$Label.add_color_override("font_color", crit)
	if def == "weak":
		$Label.text += " weak"
		$Label.add_color_override("font_color", weak)
