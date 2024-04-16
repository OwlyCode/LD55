extends Label

func _process(_delta):
	var level = get_node_or_null("/root/Game/Level/TileMap")

	if level == null:
		return

	text = "%05.2f" % level.time
