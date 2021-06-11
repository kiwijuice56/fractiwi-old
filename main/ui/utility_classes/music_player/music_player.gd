extends AudioStreamPlayer

export var volume := -23
export var transition_duration := 2.00

func _ready() -> void:
	$OutTween.connect("tween_completed", self, "out_tween_completed")
	$InTween.connect("tween_completed", self, "in_tween_completed")

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
	$OutTween.interpolate_property(self, "volume_db", volume_db, -80, transition_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$OutTween.start()
	# when the tween ends, the music will be stopped

func fade_in():
	# tween music volume up to volume 
	$InTween.interpolate_property(self, "volume_db", -80, volume, transition_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	$InTween.start()
	# when the tween ends, the music will be stopped

func out_tween_completed(object, key):
	# stop the music -- otherwise it continues to run at silent volume
	$OutTween.stop(object, key)

func in_tween_completed(object, key):
	# stop the music -- otherwise it continues to run at silent volume
	$InTween.stop(object, key)
