extends CanvasLayer
class_name PointLabel

export var miss: Color
export var repel: Color
export var nullc: Color
export var absorb: Color
export var weak: Color
export var crit: Color

enum text_types { POINT, BUFF, STATUS, FOCUS }

func set_point_text(points, is_miss: bool, is_crit: bool, def: String, type) -> void:
	offset = get_parent().get_global_transform_with_canvas().get_origin()
	if "rect_size" in get_parent():
		offset += get_parent().rect_size/2
	
	$Label.add_color_override("font_color", Color(1,1,1))
	match type:
		text_types.POINT:
			if is_miss:
				$Label.text = "Miss"
				$Label.add_color_override("font_color", miss)
			elif def == "repel":
				$Label.text = "Repel"
				$Label.add_color_override("font_color", repel)
			elif def == "null":
				$Label.text = "Null"
				$Label.add_color_override("font_color", nullc)
			elif def == "absorb":
				$Label.text = str(points) + " absorb!"
				$Label.add_color_override("font_color", absorb)
			else:
				$Label.text = str(points)
				if is_crit:
					$Label.text += " crit!"
					$Label.add_color_override("font_color", crit)
				if def == "weak":
					$Label.text += " weak!"
					$Label.add_color_override("font_color", weak)
		text_types.BUFF:
			$Label.text = def + " " + points
		text_types.STATUS:
			if is_miss:
				$Label.text = "Miss"
				$Label.add_color_override("font_color", miss)
			elif def == "repel":
				$Label.text = "Repel"
				$Label.add_color_override("font_color", repel)
			elif def == "null":
				$Label.text = "Null"
				$Label.add_color_override("font_color", nullc)
			elif def == "absorb":
				$Label.text = "Absorb!"
				$Label.add_color_override("font_color", absorb)
			else:
				$Label.text = "Inflicted %s!" % points
		text_types.FOCUS:
			if points:
				$Label.text = "Focused!"
			else:
				$Label.text = "Already focused.."
	
