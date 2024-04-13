extends Node2D

var levels = [
	preload ("res://levels/level_01.tscn"),
	preload ("res://levels/level_02.tscn")
]

var current_level = 0;
var current_level_instance = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var level = get_node("/root/Game/Level")

	if level != null:
		if level.get_node("TileMap").won:
			level.queue_free()
			current_level = (current_level + 1) % len(levels)
		elif level.get_node("TileMap").lost:
			level.queue_free()

	if current_level_instance == null:
		var instance = levels[current_level].instantiate()
		current_level_instance = instance
		get_node("/root/Game").add_child(instance)