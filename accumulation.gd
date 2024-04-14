extends Node2D

var Puffle = preload ("res://puffle.tscn")

var sound_delay = 0.25
var emission_time = 0.7
var flash_delay = 1.6
var self_destruct = 3.0
var flash = 0.05
var flashed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	emission_time -= delta
	self_destruct -= delta
	sound_delay -= delta
	flash_delay -= delta

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

	$Flash.visible = flashed and flash > 0

	flash -= delta

	var new_scale = (flash_delay) / 1.6

	if new_scale < 0:
		new_scale = 0

	$Sprite2D.scale.x = 2 * new_scale
	$Sprite2D.scale.y = 2 * new_scale

	if self_destruct < 0:
		queue_free()
