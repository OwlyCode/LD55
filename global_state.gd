extends Node

var total_time = 0.0
var death_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func score():
	return ceil(2000.0 - total_time - death_count * 5.0) as int