extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	var color = "red"

	if GlobalState.death_count == 0:
		color = "green"

	text = "[center]SCORE: [color=green]%s[/color] (CT:[color=yellow] %s[/color] / D: [color=%s]%d[/color])[/center]" % [
		GlobalState.score(),
		time_convert(GlobalState.total_time),
		color,
		GlobalState.death_count
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func time_convert(time_in_sec):
	var ms = time_in_sec - floor(time_in_sec)
	var secs = floor(time_in_sec) as int

	var seconds = secs % 60
	var minutes = (secs / 60) % 60
	var hours = (secs / 60) / 60

	if hours == 0:
		return "%02d:%02d.%02d" % [minutes, seconds, floor(ms * 100)]

	return "%02d:%02d:%02d.%02d" % [hours, minutes, seconds, floor(ms * 100)]
