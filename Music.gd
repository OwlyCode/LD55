extends AudioStreamPlayer

var playlist = [
	["Aerodynamic Pointed Hat - Laaren", preload ("res://assets/playlist/Laaren_Aerodynamic_Pointed_Hat.ogg"), 1.0],
	["Fortnite Dance On Your Grandmas Grave - Laaren", preload ("res://assets/playlist/Laaren_Fortnite_Dance_On_Your_Grandmas_Grave.ogg"), 1.5],
	["Monster Washer - Makse", preload ("res://assets/playlist/Makse_Monster_washer.ogg"), 2.0],
	["Demon Sealer - Laaren", preload ("res://assets/game_loop.mp3"), 1.0],
]

var current_music = 0

var samples = []

var hide_music_name = 3.0

var spectrum

func stop_music():
	stop()

func launch():
	current_music = randi() % len(playlist)

	spectrum = AudioServer.get_bus_effect_instance(1, 0)
	stream = playlist[current_music][1]
	GlobalState.now_playing = playlist[current_music][0]

	play()

func _on_finished():
	current_music = (current_music + 1) % len(playlist)
	stream = playlist[current_music][1]
	GlobalState.now_playing = playlist[current_music][0]

	hide_music_name = 3.0
	play()

func _process(_delta):

	if not spectrum:
		return

	var magnitude = spectrum.get_magnitude_for_frequency_range(40, 100).length()

	# if %SongDisplay.visible_ratio >= 1.0:
	# 	%SongDisplay.visible_ratio = 1.0
	# 	hide_music_name -= delta

	# if hide_music_name <= 0.0 and %SongDisplay.visible_ratio >= 0.0:
	# 	%SongDisplay.visible_ratio -= delta
	# else:
	# 	%SongDisplay.visible_ratio += delta

	samples.push_back(magnitude / 0.01)

	if len(samples) > 20:
		samples.pop_front()

	var beat_value = (samples.reduce(sum, 0) / len(samples)) / 12.0 * playlist[current_music][2];

	get_tree().call_group("beat", "beat", beat_value)

func sum(accum, number):
	return accum + number
