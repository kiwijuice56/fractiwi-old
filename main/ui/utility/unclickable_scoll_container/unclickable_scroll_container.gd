extends ScrollContainer
class_name UnclickableScrollContainer

func _ready():
	get_h_scrollbar().mouse_filter = Control.MOUSE_FILTER_IGNORE
