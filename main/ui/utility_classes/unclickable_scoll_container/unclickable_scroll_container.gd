extends ScrollContainer
class_name UnclickableScrollContainer
# Necessary as ScrollContainer scrollbars ignore mouse rules

func _ready():
	if scroll_horizontal_enabled:
		get_h_scrollbar().mouse_filter = Control.MOUSE_FILTER_IGNORE
	if scroll_vertical_enabled:
		get_v_scrollbar().mouse_filter = Control.MOUSE_FILTER_IGNORE
