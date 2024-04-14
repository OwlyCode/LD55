extends Node2D

var levels = [
	preload ("res://levels/level_04.tscn"),
	preload ("res://levels/level_02.tscn"),
	preload ("res://levels/level_03.tscn"),
	preload ("res://levels/level_01.tscn"),
]

var current_level = 0;
var current_level_instance = null;

var victory_screen: Node;
var defeat_screen: Node;

var defeat_triggered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	victory_screen = get_node("/root/Game/UI/Victory")
	defeat_screen = get_node("/root/Game/UI/Defeat")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	if current_level_instance != null:
		var tilemap = current_level_instance.get_node("TileMap")

		if tilemap.won:
			if victory_screen.visible == false:
				trigger_victory()
			%VictoryButton.grab_focus();

		elif tilemap.lost:
			%DefeatButton.grab_focus();

			if defeat_triggered == false:
				defeat_triggered = true
				if tilemap.lost_reason == "time_out":
					$TimeoutPlayer.play("time_out")
					get_node("UI/Time").visible = false
				if tilemap.lost_reason == "hit":
					get_node("Hero/AnimationPlayer").play("fall")
				if tilemap.lost_reason == "fall":
					get_node("Hero/AnimationPlayer").play("fall")

	if current_level_instance == null:
		var instance = levels[current_level].instantiate()
		current_level_instance = instance
		get_node("/root/Game").add_child(instance)

func trigger_defeat():
	defeat_screen.visible = true;
	get_node("UI/Timeout").visible = false
	%DefeatSlide.play("ui_slide");
	%DefeatButton.grab_focus();

func trigger_victory():
	victory_screen.visible = true;
	victory_screen.get_node("VBoxContainer").position.y = -1000.0
	get_node("/root/Game/VictorySound").play()
	%VictorySlide.play("slide_ui");
	%VictoryButton.grab_focus();

func _on_next_level_pressed():
	clear_level()
	current_level = (current_level + 1) % len(levels)

func _on_restart_level_pressed():
	clear_level()
	get_node("Hero/AnimationPlayer").play("idle")

func demon_released():
	get_node("/root/Game/DefeatSound").play()

func clear_level():
	defeat_triggered = false
	for node in get_tree().get_nodes_in_group("volatile"):
		node.queue_free()

	current_level_instance.queue_free()
	victory_screen.visible = false;
	defeat_screen.visible = false;
	get_node("UI/Time").visible = true