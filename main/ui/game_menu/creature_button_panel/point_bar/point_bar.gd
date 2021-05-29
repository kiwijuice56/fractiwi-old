extends HBoxContainer
# Maintains a TextureRect and accompanying labels for a point value (exp, hp, mp, etc.)

func set_data(stat: String, value: int, max_value: int):
	$NameLabel.text = stat.to_upper()
	$PointLabel.text = str(value)
	$TextureProgress.max_value = max_value
	$TextureProgress.value = value
