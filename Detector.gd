extends Area2D

var tilemap: TileMap = null

func _process(_delta):
	if tilemap == null:
		return

	if has_overlapping_areas():

		var coords = tilemap.local_to_map(position)

		tilemap.set_cell(1, coords, -1)

		return