extends CPUParticles2D

var self_destruct = 5.0
var flash = 0.03

# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flash < 0.0:
		$Sprite2D.visible = false

	flash -= delta

	self_destruct -= delta

	if self_destruct < 0:
		queue_free()
