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

var dashing_time = 0.0
var dash_exit_time = 0.0
var drift_time = 0.0

func _physics_process(delta):

	if dash_status not in [DashStatus.DASHING, DashStatus.DASH_EXIT]:
		direction = Input.get_vector("left", "right", "up", "down")

		velocity = (direction * MOVE_SPEED) * delta + drift

		#drift_effect = lerpf(0.0, 1.0, clampf(drift_duration / DRIFT_DURATION, 0.0, 1.0))
		#drift_duration -= delta

		# drift *= drift_effect

	# DRIFT
	if dash_status == DashStatus.DRIFTING:
		drift_time -= delta
		drift_time = clampf(drift_time, 0.0, DRIFTING_TIME)
		drift = drift_direction * lerpf(0.0, DRIFT_INITIAL_SPEED, drift_time / DRIFTING_TIME) * delta

		if drift_time <= 0:
			dash_status = DashStatus.NONE
			print("FINISHED")

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
			print("DRIFT")

	# DASH
	if dash_status == DashStatus.DASHING:
		dashing_time -= delta

		var dir = Vector2.RIGHT.rotated(transform.get_rotation())
		velocity = dir.normalized() * DASH_SPEED * delta

		if dashing_time <= 0:
			dash_status = DashStatus.DASH_EXIT
			print("EXIT")

	if dash_asked:
		print("DASH")
		dash_asked = false
		dash_status = DashStatus.DASHING
		dashing_time = DASH_TIME
		dash_exit_time = DASH_EXIT_TIME
		drift_time = DRIFTING_TIME

	# else:
	# 	velocity *= 0.9

	# $DriftSmoke.emitting = drift_effect > 0.0

	# if dash_asked:
	# 	hard_dash = DASH_DURATION
	# 	dashing = true
	# 	dash_asked = false

	# if dashing:
	# 	hard_dash -= delta
	# 	var dir = Vector2.RIGHT.rotated(transform.get_rotation())
	# 	velocity = dir.normalized() * dash_speed * delta

	# if hard_dash <= 0 and dashing:
	# 	drift_duration = DRIFT_DURATION
	# 	dashing = false
	# 	drift = velocity

	move_and_slide()
