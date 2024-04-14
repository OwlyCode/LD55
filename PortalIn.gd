extends Node2D

@export var out: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("hero"):
		body.position = out.position

		if out.is_in_group("directional"):
			var dir = Vector2.RIGHT.rotated(out.transform.get_rotation())
			body.direction = dir;
