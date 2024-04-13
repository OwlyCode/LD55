extends Label

func _process(_delta):
	var level = get_node("/root/Game/Level/TileMap")

	if level == null:
		return

	text = "%.2f" % level.time
