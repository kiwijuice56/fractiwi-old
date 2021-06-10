extends PanelContainer
class_name AffinityPanel

func set_affinity(affinity: String, status):
	$VSplitContainer/AffinityIcon.set_icon(affinity)
	var text: String
	match status:
		"weak": text = "wk"
		"resist": text = "rs"
		"repel": text = "rp"
		"null": text = "nu"
		"absorb": text = "ab"
		_:
			text = str((status/10)%10)
	$VSplitContainer/Label.text = text
