extends Node
# Performs basic effects on UI

export var default_fade_time: float
export var default_slide_time: float

func fade(node: Node, direction: String, fade_time: float) -> void:
	#node.visible = true
	if direction == "hide":
		$FadeTween.interpolate_property(node, "modulate", node.modulate, Color(0,0,0,0), fade_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else:
		$FadeTween.interpolate_property(node, "modulate", Color(0,0,0,0), Color(1,1,1,1), fade_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$FadeTween.start()
	#if direction == "hide":
		#yield($FadeTween, "tween_completed")
		#node.visible = false 

func slide(node: Node, axis: String, new_pos: float, slide_time: float) -> void:
	$SlideTween.interpolate_property(node, "rect_position:" + axis, node.get("rect_position:" + axis), new_pos, slide_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$SlideTween.start()
