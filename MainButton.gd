extends Button

# Called when the node enters the scene tree for the first time.

func _on_pressed():
	GlobalState.death_count = 0
	GlobalState.total_time = 0.0

	GlobalState.music.launch()
	get_tree().change_scene_to_file("res://game.tscn")
