extends Node2D

var levels = [
	preload ("res://levels/level_02.tscn"),
	preload ("res://levels/level_01.tscn"),
]

var current_level = 0;
var current_level_instance = null;

var victory_screen: Node;
var defeat_screen: Node;

# Called when the node enters the scene tree for the first time.
func _ready():
	victory_screen = get_node("/root/Game/UI/Victory")
	defeat_screen = get_node("/root/Game/UI/Defeat")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if current_level_instance != null:
		if current_level_instance.get_node("TileMap").won:
			if victory_screen.visible == false:
				victory_screen.get_node("VBoxContainer").position.y = -1000.0
				get_node("/root/Game/VictorySound").play()
				%VictorySlide.play("slide_ui");

			victory_screen.visible = true;
			%VictoryButton.grab_focus();

		elif current_level_instance.get_node("TileMap").lost:
			if defeat_screen.visible == false:
				get_node("/root/Game/DefeatSound").play()
				%DefeatSlide.play("ui_slide");

			defeat_screen.visible = true;
			%DefeatButton.grab_focus();

	if current_level_instance == null:
		var instance = levels[current_level].instantiate()
		current_level_instance = instance
		get_node("/root/Game").add_child(instance)

func _on_next_level_pressed():
	clear_level()
	current_level = (current_level + 1) % len(levels)

func _on_restart_level_pressed():
	clear_level()

func clear_level():
	for node in get_tree().get_nodes_in_group("volatile"):
		node.queue_free()

	current_level_instance.queue_free()
	victory_screen.visible = false;
	defeat_screen.visible = false;