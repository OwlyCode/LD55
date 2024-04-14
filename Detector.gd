extends Area2D

var Puffle = preload ("res://symbol_puffle.tscn")

var tilemap: TileMap = null
var popped = false

func _process(_delta):
	if tilemap == null:
		return

	if !popped and has_overlapping_areas():
		popped = true
		var puffle = Puffle.instantiate();
		puffle.position = position;
		get_tree().root.add_child(puffle)

		var coords = tilemap.local_to_map(position)

		tilemap.set_cell(1, coords, -1)

		return