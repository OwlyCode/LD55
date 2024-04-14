extends CharacterBody2D

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
		iframe = 0.5
		velocity = velocity.bounce(collision.get_normal())
		bounce_count -= 1
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()

		if bounce_count < 0:
			queue_free()
