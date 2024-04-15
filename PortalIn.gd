extends Node2D

@export var out: Node

var transiting = true
var points = []
const LINE_SIZE = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(LINE_SIZE):
		points.push_back(to_local(global_position.lerp(out.global_position, i / LINE_SIZE)))

		#$Line2D.add_point(to_local(position.lerp(out.position, i / LINE_SIZE)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if transiting:
		$Line2D.remove_point(0)

		if $Line2D.get_point_count() == 0:
			transiting = false

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("hero"):
		$Enter.play()
		body.global_position = out.global_position

		transiting = true

		for point in points:
			$Line2D.add_point(point)

		if out.is_in_group("directional"):
			var dir = Vector2.RIGHT.rotated(out.transform.get_rotation())
			body.direction = dir;

func beat(beat_value):
	$Light.energy = 4.0 + 2.5 * beat_value
	$Light.texture_scale = 0.3 + 0.2 * beat_value
