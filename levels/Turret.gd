extends Node2D

@export var cooldown = 0.0;
var enabled = false;

var Bullet = preload ("res://bullet.tscn")

enum FireMode {
	SHOTGUN,
	MINIGUN,
	RAFALE,
}

@export var firemode: FireMode = FireMode.SHOTGUN

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var hero = get_tree().get_nodes_in_group("hero")[0]

	look_at(hero.position)

	if enabled:
		cooldown -= delta

	if enabled and cooldown < 0:
		if firemode == FireMode.SHOTGUN:
			shotgun()
		if firemode == FireMode.MINIGUN:
			minigun()
		if firemode == FireMode.RAFALE:
			rafale()

func shotgun():
	cooldown = 3.0

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

func minigun():
	cooldown = 0.25
	$Fire.play()

	var a = Bullet.instantiate()
	a.speed = 500.0
	a.start(global_position, rotation)
	get_tree().root.add_child(a)

var rafale_count = 0

func rafale():
	if rafale_count < 2:
		cooldown = 0.25
		rafale_count += 1
	else:
		rafale_count = 0
		cooldown = 3.0

	$Fire.play()
	var a = Bullet.instantiate()
	a.speed = 300.0
	a.start(global_position, rotation)
	get_tree().root.add_child(a)

func player_moved():
	enabled = true

func level_ended():
	enabled = false