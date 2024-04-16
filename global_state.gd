extends Node

var total_time = 0.0
var death_count = 0

var _bus := AudioServer.get_bus_index("Master")
var master_sound: float = db_to_linear(AudioServer.get_bus_volume_db(_bus))

var Music = preload ("res://game_music.tscn")
var music

var current_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	music = Music.instantiate()
	add_child(music)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func score():
	return ceil(2000.0 - total_time - death_count * 5.0) as int

enum GameState {IDLE, STARTED, LOST, WON}
