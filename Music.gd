extends AudioStreamPlayer

var playlist = [
	["Aerodynamic Pointed Hat - Laaren", preload ("res://assets/playlist/Laaren_Aerodynamic_Pointed_Hat.ogg"), 1.0],
	["Fortnite Dance On Your Grandmas Grave - Laaren", preload ("res://assets/playlist/Laaren_Fortnite_Dance_On_Your_Grandmas_Grave.ogg"), 1.5],
	["Monster Washer - Makse", preload ("res://assets/playlist/Makse_Monster_washer.ogg"), 2.0],
	["Demon Sealer - Laaren", preload ("res://assets/game_loop.mp3"), 1.0],
]

var current_music = 0

var samples = []

var bpm = 0.5

var hide_music_name = 3.0

var spectrum

func _ready():
	current_music = randi() % len(playlist)

	spectrum = AudioServer.get_bus_effect_instance(1, 0)
	stream = playlist[current_music][1]
	%SongDisplay.text = "Now playing: " + playlist[current_music][0]
	%SongDisplay.visible_ratio = 0.0
	play()

func _on_finished():
	current_music = (current_music + 1) % len(playlist)
	stream = playlist[current_music][1]
	%SongDisplay.text = "Now playing: " + playlist[current_music][0]
	hide_music_name = 3.0
	play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if %SongDisplay.visible_ratio >= 1.0:
		%SongDisplay.visible_ratio = 1.0
		hide_music_name -= delta

	if hide_music_name <= 0.0 and %SongDisplay.visible_ratio >= 0.0:
		%SongDisplay.visible_ratio -= delta
	else:
		%SongDisplay.visible_ratio += delta

	var time = get_playback_position() + AudioServer.get_time_since_last_mix()
	# Compensate for output latency.
	time -= AudioServer.get_output_latency()

	time = time - floor(time)

	# if time > 0.5:
	# 	time = time - 0.5
	# 	get_node("/root/Game/Visualizer").self_modulate = Color.html("#555555").lerp(Color.BLACK, time / 0.5)
	# else:
	# 	get_node("/root/Game/Visualizer").self_modulate = Color.html("#555555").lerp(Color.BLACK, 1.0 - time / 0.5)

	var magnitude = [
		spectrum.get_magnitude_for_frequency_range(40, 100).length(),
		spectrum.get_magnitude_for_frequency_range(500, 1000).length(),
		spectrum.get_magnitude_for_frequency_range(1000, 1500).length(),
		spectrum.get_magnitude_for_frequency_range(1500, 2000).length(),
		spectrum.get_magnitude_for_frequency_range(2000, 2500).length()
	];

	samples.push_back(magnitude[0] / 0.01)

	if len(samples) > 20:
		samples.pop_front()

	var beat_value = (samples.reduce(sum, 0) / len(samples)) / 12.0 * playlist[current_music][2];

	get_node("/root/Game/Visualizer/Left").position.y = 30 - beat_value * 30.0
	get_node("/root/Game/Visualizer/Right").position.y = -20 + beat_value * 30.0

	for node in get_tree().get_nodes_in_group("beat"):
		node.beat(beat_value)

	# get_node("/root/Game/Visualizer").self_modulate = Color.WHITE.lerp(Color.BLACK, 1.0 - samples.reduce(sum, 0) / len(samples))

func sum(accum, number):
	return accum + number
