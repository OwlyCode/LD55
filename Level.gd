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

	if !won and !lost and started:
		time -= delta;

	if time < 0:
		lost_reason = "time_out"
		lost = true
		time = 0.0

	if get_node("/root/Game/Hero").velocity != Vector2.ZERO:
		started = true

	if !lost:
		won = len(self.get_used_cells(1)) == 0
