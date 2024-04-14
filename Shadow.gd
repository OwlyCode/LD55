extends Node2D

var MAX_LIFETIME = 0.3;
var lifetime = MAX_LIFETIME

var start_color = Color.DARK_BLUE;
var end_color = Color.LIGHT_BLUE;

# Called when the node enters the scene tree for the first time.
func _ready():
	start_color.a = 0.6;
	end_color.a = 0.0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifetime -= delta

	modulate = start_color.lerp(end_color, 1.0 - lifetime / MAX_LIFETIME)

	if lifetime < 0:
		queue_free()
