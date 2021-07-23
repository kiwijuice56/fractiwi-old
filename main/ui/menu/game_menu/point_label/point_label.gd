extends CanvasLayer
class_name PointLabel

export var miss: Color
export var repel: Color
export var nullc: Color
export var absorb: Color
export var weak: Color
export var crit: Color

enum text_types { POINT, BUFF, STATUS, FOCUS, CONCENTRATE }

func set_point_text(points, is_miss: bool, is_crit: bool, def: String, extra: String, type) -> void:
	offset = get_parent().get_global_transform_with_canvas().get_origin()
	if "rect_size" in get_parent():
		offset += get_parent().rect_size/2
	$Label.add_color_override("font_color", Color(1,1,1))
	$Label/Label2.add_color_override("font_color", Color(1,1,1))
	match type:
		text_types.POINT:
			$Label/Label2.text = ""
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
				$Label.text = "+" + str(points) + " " + extra
				$Label.add_color_override("font_color", absorb)
				$Label/Label2.text = "absorb"
				$Label/Label2.add_color_override("font_color", absorb)
			else:
				$Label.text = str(points) + " " + extra
				if points > 0:
					$Label.text = "+" + str(points) + " " + extra
					$Label.add_color_override("font_color", absorb)
				if is_crit:
					$Label/Label2.text += "crit"
					$Label/Label2.add_color_override("font_color", crit)
					$Label.add_color_override("font_color", crit)
				if def == "weak":
					$Label/Label2.text += " weak"
					$Label/Label2.add_color_override("font_color", weak)
					$Label.add_color_override("font_color", weak)
		text_types.BUFF:
			var text_stat := ""
			match def:
				"Defense":
					text_stat = "DEF"
				"Attack":
					text_stat = "ATK"
				"Hit/eva":
					text_stat = "HIT"
			$Label/Label2.text = text_stat
			$Label.text = ("+" if int(points) > 0 else "") + points
		text_types.STATUS:
			$Label/Label2.text = ""
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
				$Label.text = "Absorb"
				$Label.add_color_override("font_color", absorb)
			elif def == "weak":
				$Label.add_color_override("font_color", weak)
				$Label/Label2.add_color_override("font_color", weak)
				$Label.text = points
				$Label/Label2.text = "inflicted weak"
			else:
				$Label.text = points.capitalize()
				$Label/Label2.text = "Inflicted"
		text_types.FOCUS:
			$Label/Label2.text = ""
			if points:
				$Label.text = "Focused!"
			else:
				$Label.text = "Already focused.."
		text_types.CONCENTRATE:
			$Label/Label2.text = ""
			if points:
				$Label.text = "Concentrated!"
			else:
				$Label.text = "Already concentrated.."
