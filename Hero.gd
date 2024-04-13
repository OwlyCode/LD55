extends CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	# dashing = Input.is_action_pressed("dash")

	if Input.is_action_just_pressed("dash"):
		dash_asked = true

	$DriftSmoke.emitting = dash_status == DashStatus.DRIFTING and (last_position.distance_to(position) > 5.0 * delta)

	last_position = position

	if velocity:
		look_at(transform.origin + direction)

	# if $CleanerDetection.get_overlapping_bodies() > 0:
	# 	for x in $CleanerDetection.$CollisionShape2D.extent

	# 	pass

			# print(rad_to_deg(trace_vector.angle_to(dash_vector)))
			# print(closest.distance_to(local_position))

var dash_asked = false

var drift = Vector2.ZERO
var drift_direction = Vector2.ZERO
var direction = Vector2.ZERO

enum DashStatus {DASHING, DASH_EXIT, DRIFTING, NONE}

var dash_status = DashStatus.NONE;

var last_position = Vector2.ZERO

const MOVE_SPEED = 10000 * 0.5
const DASH_SPEED = 10000 * 2.5;
const DRIFT_INITIAL_SPEED = DASH_SPEED / 3.0;

const DASH_TIME = 0.10;
const DASH_EXIT_TIME = 0.05;
const DRIFTING_TIME = 0.5;

const SNAP_DISTANCE = 16.0
const SNAP_ANGLE = 15.0

var dashing_time = 0.0
var dash_exit_time = 0.0
var drift_time = 0.0

func _physics_process(delta):

	if dash_status not in [DashStatus.DASHING, DashStatus.DASH_EXIT]:
		direction = Input.get_vector("left", "right", "up", "down")

		velocity = (direction * MOVE_SPEED) * delta + drift

	# DRIFT
	if dash_status == DashStatus.DRIFTING:
		drift_time -= delta
		drift_time = clampf(drift_time, 0.0, DRIFTING_TIME)
		drift = drift_direction * lerpf(0.0, DRIFT_INITIAL_SPEED, drift_time / DRIFTING_TIME) * delta

		if drift_time <= 0:
			dash_status = DashStatus.NONE

	# EXIT
	if dash_status == DashStatus.DASH_EXIT:
		velocity = Vector2.ZERO
		dash_exit_time -= delta
		dash_exit_time = clampf(dash_exit_time, 0.0, DASH_EXIT_TIME)

		var dir = Vector2.RIGHT.rotated(transform.get_rotation())
		velocity = dir.normalized() * lerpf(DRIFT_INITIAL_SPEED, DASH_SPEED, dash_exit_time / DASH_EXIT_TIME) * delta

		if dash_exit_time <= 0:
			dash_status = DashStatus.DRIFTING
			drift_direction = velocity.normalized()
			drift = velocity

	# DASH
	if dash_status == DashStatus.DASHING:
		dashing_time -= delta

		var dir = Vector2.RIGHT.rotated(transform.get_rotation())
		velocity = dir.normalized() * DASH_SPEED * delta

		if dashing_time <= 0:
			dash_status = DashStatus.DASH_EXIT

	if dash_asked:
		dash_asked = false
		dash_status = DashStatus.DASHING
		dashing_time = DASH_TIME
		dash_exit_time = DASH_EXIT_TIME
		drift_time = DRIFTING_TIME

	# SNAPPING
	var snaps = get_tree().get_nodes_in_group("snapping")

	for snap in snaps:
		var local_position = snap.to_local(self.position)
		var local_nose_position = snap.to_local(self.position + 20.0 * Vector2.RIGHT.rotated(transform.get_rotation()))

		var closest = snap.curve.get_closest_point(local_position)
		var nose_closest = snap.curve.get_closest_point(local_nose_position)

		var distance = closest.distance_to(local_position)

		if distance < SNAP_DISTANCE:

			var trace_vector = nose_closest - closest;
			var dash_vector = local_nose_position - local_position;

			var angle = trace_vector.angle_to(dash_vector)
			var deg_angle = rad_to_deg(angle)

			if abs(deg_angle) < SNAP_ANGLE:
				velocity = velocity.rotated( - angle * 0.15)
				direction = direction.rotated( - angle * 0.15)
				drift = drift.rotated( - angle * 0.15)

				print(angle)

	move_and_slide()
