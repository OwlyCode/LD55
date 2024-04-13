extends TileMap

var detector = preload ("res://detector.tscn")

var time = 20.0;
var won = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in self.get_used_cells(1):

		var coords = map_to_local(x)

		var instance = detector.instantiate()
		add_child(instance)
		instance.position = coords
		instance.tilemap = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !won:
		time -= delta;

	won = len(self.get_used_cells(1)) == 0
