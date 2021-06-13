extends AudioStreamPlayer
class_name SoundPlayer

func play_sound(sound: String) -> void:
	get_node(sound).playing = true
