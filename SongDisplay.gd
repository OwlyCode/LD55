extends Label

func _process(delta):
	text = "Now playing: %s" % GlobalState.now_playing

func beat(beat_value):
	self_modulate = Color.BLACK.lerp(Color.WHITE, 0.5 + beat_value)