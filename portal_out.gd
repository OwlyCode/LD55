extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func beat(beat_value):
	$Light.energy = 4.0 + 2.5 * beat_value
	$Light.texture_scale = 0.3 + 0.2 * beat_value