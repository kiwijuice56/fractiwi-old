extends AudioStreamPlayer
class_name MenuSoundPlayer

func play_sound(effect: String) -> void:
	get_node(effect).playing = true
