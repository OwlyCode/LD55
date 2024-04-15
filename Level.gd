extends TileMap

var detector = preload ("res://detector.tscn")

@export var level_time = 20.0

var time = 0.0;
var won = false
var lost = false
var lost_reason

var started = false;

func _ready():
	time = level_time

	var hero = get_node("/root/Game/Hero");

	hero.position = get_node("../Spawn").position
	hero.alive = true
	hero.iframe = 10
	hero.won = false
	hero.visible = true
	hero.freeze()

	for x in self.get_used_cells(1):

		var coords = map_to_local(x)

		var instance = detector.instantiate()
		add_child(instance)
		instance.position = coords
		instance.tilemap = self

func _process(delta):
	var hero = get_node("/root/Game/Hero");

	if !hero.alive:
		lost_reason = hero.death_reason
		lost = true
		for node in get_tree().get_nodes_in_group("player_moved"):
			node.level_ended()

	if !won and !lost and started:
		time -= delta;

	if time < 0:
		lost_reason = "time_out"
		lost = true
		time = 0.0
		hero.alive = false

		for node in get_tree().get_nodes_in_group("ritual"):
			node.ritual()

	if get_node("/root/Game/Hero").velocity != Vector2.ZERO:
		if !started:
			for node in get_tree().get_nodes_in_group("player_moved"):
				node.player_moved()

		started = true

	var was_won = won

	if !lost:
		won = len(self.get_used_cells(1)) == 0

	if won and !was_won:
		get_node("/root/Game/Hero").win()
		for node in get_tree().get_nodes_in_group("player_moved"):
			node.level_ended()