extends Node2D

var levels = [
	preload ("res://levels/level_01_move_00.tscn"),
	preload ("res://levels/level_01_move_02.tscn"),
	preload ("res://levels/level_02_dash_01.tscn"),
	preload ("res://levels/level_02_dash_01b.tscn"),
	preload ("res://levels/level_02_dash_02.tscn"),
	preload ("res://levels/level_02_dash_03.tscn"),
	preload ("res://levels/level_02_dash_04.tscn"),
	preload ("res://levels/level_02_dash_05.tscn"),
	preload ("res://levels/level_02_dash_05b.tscn"),
	preload ("res://levels/level_02_dash_06.tscn"),
	preload ("res://levels/level_03_turret_01.tscn"),
	preload ("res://levels/level_03_turret_01b.tscn"),
	preload ("res://levels/level_03_turret_02.tscn"),
	preload ("res://levels/level_03_turret_03.tscn"),
	preload ("res://levels/level_03_turret_04.tscn"),
	preload ("res://levels/level_03_turret_05.tscn"),
	preload ("res://levels/level_04_portal_00.tscn"),
	preload ("res://levels/level_04_portal_01.tscn"),
	preload ("res://levels/level_04_portal_01c.tscn"),
	preload ("res://levels/level_04_portal_02.tscn"),
	preload ("res://levels/level_04_portal_03.tscn"),
	preload ("res://levels/level_05_end_00.tscn"),
	preload ("res://levels/level_05_end_01.tscn"),
	preload ("res://levels/level_05_end_02.tscn"),
	preload ("res://levels/level_05_end_03.tscn"),
	preload ("res://levels/level_05_end_04.tscn"),
	preload ("res://levels/level_05_end_06.tscn"),
	preload ("res://levels/level_05_end_07.tscn"),
	preload ("res://levels/level_05_end_final.tscn"),
]

var current_level = 0;
var current_level_instance = null;

var victory_screen: Node;
var defeat_screen: Node;

var defeat_triggered = false

var current_level_time = 0.0

var sentences_good = [
	"GG, no re",
	"A wizard is never late!",
	"Say hello to the Devil for me!",
	"See you later demonizer!",
	"In a while, old vile",
	"See you in a thousand years, looser!",
	"You shall not pass! n00b.",
	# "Looks like you got...(••) / ( ••)>⌐■-■ / (⌐■_■)...unsummoned...YEEEAAAHH!"
]

var sentences_bad = [
	"Meh. Global warming had doomed us already.",
    "Fly, you fools!",
	"I'm too old for this seal.",
]

# Called when the node enters the scene tree for the first time.
func _ready():
	victory_screen = get_node("/root/Game/UI/Victory")
	defeat_screen = get_node("/root/Game/UI/Defeat")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_level_instance != null:
		var tilemap = current_level_instance.get_node("TileMap")

		if tilemap.won:
			if victory_screen.visible == false:
				trigger_victory()

		elif tilemap.lost:
			if defeat_triggered == false:
				GlobalState.death_count += 1
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

		var hero = get_node("/root/Game/Hero");

		var middle = instance.get_node_or_null("Middle")

		hero.position = instance.get_node("Spawn").position

		if middle:
			var camera = get_node("/root/Game/Camera2D")
			hero.position += camera.position - middle.position

		hero.alive = true
		hero.iframe = 30
		hero.won = false
		hero.visible = true
		hero.freeze()

		if middle:
			var camera = get_node("/root/Game/Camera2D")
			instance.position = camera.position - middle.position

		current_level_instance = instance
		get_node("/root/Game").add_child(instance)

func time_convert(time_in_sec):
	var ms = time_in_sec - floor(time_in_sec)
	var secs = floor(time_in_sec) as int

	var seconds = secs % 60
	var minutes = (secs / 60) % 60
	var hours = (secs / 60) / 60

	if hours == 0:
		return "%02d:%02d.%02d" % [minutes, seconds, floor(ms * 100)]

	return "%02d:%02d:%02d.%02d" % [hours, minutes, seconds, floor(ms * 100)]

func trigger_defeat():
	%DefeatPunchline.text = sentences_bad.pick_random()
	%DefeatScore.text = "[center]Cumulated time: %s (unchanged)\nDeaths: %d ([color=red]+1[/color])[/center]" % [time_convert(GlobalState.total_time), GlobalState.death_count]

	defeat_screen.visible = true;
	defeat_screen.self_modulate = Color.hex(0x00000000)
	defeat_screen.get_node("Demon").self_modulate = Color.hex(0x00000000)
	defeat_screen.get_node("VBoxContainer").position.y = 1000.0

	get_node("UI/Timeout").visible = false

	%DefeatSlide.play("ui_slide");
	%DefeatButton.grab_focus();

func trigger_victory():
	var tilemap = current_level_instance.get_node("TileMap")

	current_level_time = tilemap.level_time - tilemap.time
	%VictoryPunchline.text = sentences_good.pick_random()
	%VictoryScore.text = "[center]Cumulated time: %s ([color=yellow]+%s[/color])\nDeaths:%d ([color=green]+0[/color])[/center]" % [time_convert(GlobalState.total_time + current_level_time), time_convert(current_level_time), GlobalState.death_count]

	victory_screen.visible = true;
	victory_screen.self_modulate = Color.hex(0x00000000)
	victory_screen.get_node("VBoxContainer").position.y = -1000.0
	victory_screen.get_node("Wizard").position.x = -2000
	%VictorySlide.play("slide_ui");
	%VictoryButton.grab_focus();

func _on_next_level_pressed():
	GlobalState.total_time += current_level_time
	clear_level()
	current_level = current_level + 1

	if current_level >= len(levels):
		get_tree().change_scene_to_file("res://EndCredits.tscn")

func _on_restart_level_pressed():
	clear_level()
	get_node("Hero/AnimationPlayer").play("idle")

func demon_released():
	get_node("/root/Game/DefeatSound").play()

func demon_sealed():
	get_node("/root/Game/VictorySound").play()

func preclear_level():
	for node in get_tree().get_nodes_in_group("volatile"):
		node.queue_free()

func clear_level():
	current_level_time = 0.0

	defeat_triggered = false
	for node in get_tree().get_nodes_in_group("volatile"):
		node.queue_free()

	current_level_instance.queue_free()
	victory_screen.visible = false;
	defeat_screen.visible = false;
	get_node("UI/Time").visible = true