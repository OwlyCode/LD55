extends CharacterBody2D

var Puffle = preload ("res://bullet_puffle.tscn")

var speed = 100
var iframe = 0.0

var bounce_count = 1

func start(_position, _direction):
	rotation = _direction
	position = _position
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	look_at(position + velocity)
	var collision = move_and_collide(velocity * delta)

	iframe -= delta

	if collision and iframe <= 0:
		$Bounce.play()
		iframe = 0.1
		velocity = velocity.bounce(collision.get_normal())
		bounce_count -= 1
		if collision.get_collider().has_method("hit"):
			if collision.get_collider().hit():
				puff()
				queue_free()

		if bounce_count < 0:
			puff()
			queue_free()

func beat(beat_value):
	$Light.scale.x = 0.2 + 0.4 * beat_value
	$Light.scale.y = 0.1 + 0.4 * beat_value

func puff():
	var puffle = Puffle.instantiate()
	puffle.global_position = global_position
	puffle.emitting = true
	get_tree().root.add_child(puffle)