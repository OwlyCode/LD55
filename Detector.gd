extends Area2D

var tilemap: TileMap = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if tilemap == null:
		return

	if has_overlapping_areas():

		var coords = tilemap.local_to_map(position)

		tilemap.set_cell(1, coords, -1)

		return