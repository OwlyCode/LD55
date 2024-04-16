extends TileMap

var detector = preload ("res://detector.tscn")

@export var level_time = 20.0

var time = 0.0;
var lost_reason

var game_state
var hero

func _ready():
	time = level_time

	for x in self.get_used_cells(1):

		var coords = map_to_local(x)

		var instance = detector.instantiate()
		add_child(instance)
		instance.position = coords
		instance.tilemap = self

	hero = get_node("/root/Game/Hero");

func player_moved():
	game_state = GlobalState.GameState.STARTED

func _process(delta):
	if game_state in [GlobalState.GameState.LOST, GlobalState.GameState.WON, GlobalState.GameState.IDLE]:
		return

	if !hero.alive:
		lost_reason = hero.death_reason
		game_state = GlobalState.GameState.LOST
		get_tree().call_group("player_moved", "level_ended")

	if game_state == GlobalState.GameState.STARTED:
		time -= delta;

	if time < 0:
		lost_reason = "time_out"
		game_state = GlobalState.GameState.LOST
		time = 0.0
		hero.alive = false

		get_tree().call_group("ritual", "ritual")

	if game_state == GlobalState.GameState.STARTED and len(self.get_used_cells(1)) == 0:
		game_state = GlobalState.GameState.WON
		get_tree().call_group("player_moved", "level_ended")
		get_node("/root/Game/Hero").win()
