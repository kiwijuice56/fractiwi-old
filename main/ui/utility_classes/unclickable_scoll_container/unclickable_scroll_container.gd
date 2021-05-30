extends ScrollContainer
class_name UnclickableScrollContainer
# Necessary as ScrollContainer scrollbars ignore mouse rules

func _ready():
	get_h_scrollbar().mouse_filter = Control.MOUSE_FILTER_IGNORE
