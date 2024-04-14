extends Area2D

var Puffle = preload ("res://symbol_puffle.tscn")

var tilemap: TileMap = null
var popped = false

func _process(_delta):
	if tilemap == null:
		return

	if !popped and has_overlapping_areas():
		$AudioStreamPlayer.play()
		popped = true
		var puffle = Puffle.instantiate();
		puffle.position = position;
		get_tree().root.add_child(puffle)

		var coords = tilemap.local_to_map(position)

		tilemap.set_cell(1, coords, -1)

		$Light.queue_free()

		return

func beat(beat_value):
	if get_node_or_null("Light"):
		$Light.scale.x = 0.2 + 0.4 * beat_value
		$Light.scale.y = 0.2 + 0.4 * beat_value
