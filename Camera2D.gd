extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func camera_shake(intensity=1, duration=1):
	for i in range(duration):
		position.x += intensity
		position.y += intensity
		await get_tree().create_timer(0.01).timeout
		position.x -= intensity
		position.y -= intensity
		await get_tree().create_timer(0.01).timeout