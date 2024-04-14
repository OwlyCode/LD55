extends Node2D

var Puffle = preload ("res://puffle.tscn")

var sound_delay = 0.25
var emission_time = 0.7
var flash_delay = 1.6
var self_destruct = 3.0
var flash = 0.05
var flashed = false
var transiting = false

const LINE_SIZE = 20.0
var points = []

func _ready():
	for i in range(LINE_SIZE):
		points.push_back(to_local(position.lerp(position + Vector2(1000.0, -1000.0), i / LINE_SIZE)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	emission_time -= delta
	self_destruct -= delta
	sound_delay -= delta
	flash_delay -= delta

	if transiting:
		$Line2D.remove_point(0)

		if $Line2D.get_point_count() == 0:
			transiting = false

	if sound_delay < 0:
		$Sound.play()
		sound_delay = 1000.0

	if emission_time < 0:
		$Particles.emitting = false

	if flash_delay < 0:
		if !flashed:
			flash = 0.05
			flashed = true
			var puffle = Puffle.instantiate()
			puffle.position = position
			get_tree().root.add_child(puffle)
			get_node("/root/Game/Hero").visible = false
			transiting = true
			for point in points:
				$Line2D.add_point(point)

	$Flash.visible = flashed and flash > 0

	flash -= delta

	var new_scale = (flash_delay) / 1.6

	if new_scale < 0:
		new_scale = 0

	$Sprite2D.scale.x = 2 * new_scale
	$Sprite2D.scale.y = 2 * new_scale

	if self_destruct < 0:
		queue_free()
