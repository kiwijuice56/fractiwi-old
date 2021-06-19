extends AudioStreamPlayer

export var volume := -23
export var transition_duration := 2.00

func play_audio(audio: AudioStream) -> void:
	if audio == stream: return
	if stream:
		fade_out()
		yield($OutTween, "tween_completed")
	stream = audio
	volume_db = -80
	playing = true
	fade_in()

func fade_out():
	# tween music volume down to 0
	$OutTween.interpolate_property(self, "volume_db", volume_db, -80, transition_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$OutTween.start()

func fade_in():
	# tween music volume up to volume 
	$InTween.interpolate_property(self, "volume_db", -80, volume, transition_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$InTween.start()
