extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus()

func _on_pressed():
	get_tree().change_scene_to_file("res://game.tscn")
