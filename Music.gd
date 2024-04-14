extends AudioStreamPlayer

var samples = []

var bpm = 0.5

var spectrum

func _ready():
	spectrum = AudioServer.get_bus_effect_instance(1, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time = get_playback_position() + AudioServer.get_time_since_last_mix()
	# Compensate for output latency.
	time -= AudioServer.get_output_latency()

	time = time - floor(time)

	print("Time is: ", time - floor(time))

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
	print(magnitude)

	samples.push_back(magnitude[0] / 0.01)

	if len(samples) > 20:
		samples.pop_front()

	get_node("/root/Game/Visualizer/Left").position.y = 30 - (samples.reduce(sum, 0) / len(samples)) * 30.0
	get_node("/root/Game/Visualizer/Right").position.y = -20 + (samples.reduce(sum, 0) / len(samples)) * 30.0

	# get_node("/root/Game/Visualizer").self_modulate = Color.WHITE.lerp(Color.BLACK, 1.0 - samples.reduce(sum, 0) / len(samples))

func sum(accum, number):
	return accum + number
