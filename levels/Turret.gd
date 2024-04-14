extends Node2D

const FIRERATE = 3.0;

var cooldown = 2.0;

var Bullet = preload ("res://bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var hero = get_tree().get_nodes_in_group("hero")[0]

	look_at(hero.position)

	cooldown -= delta

	if cooldown < 0:
		cooldown = FIRERATE
		shoot()

func shoot():
	$Fire.play()
	var a = Bullet.instantiate()
	a.start(global_position, rotation + 0.25)

	var b = Bullet.instantiate()
	b.start(global_position, rotation)

	var c = Bullet.instantiate()
	c.start(global_position, rotation - 0.25)

	get_tree().root.add_child(a)
	get_tree().root.add_child(b)
	get_tree().root.add_child(c)