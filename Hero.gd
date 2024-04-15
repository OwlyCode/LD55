extends CharacterBody2D

var Shadow = preload ("res://shadow.tscn")
var Puffle = preload ("res://puffle.tscn")
var Accumulator = preload ("res://accumulation.tscn")

const SHADOW_DELAY = 0.05

var shadow_delay_current = SHADOW_DELAY;
var iframe = 10
var dash_asked = false

var drift = Vector2.ZERO
var drift_direction = Vector2.ZERO
var direction = Vector2.ZERO
var alive = true
var death_reason

enum DashStatus {DASHING, DASH_EXIT, DRIFTING, NONE}

var dash_status = DashStatus.NONE;

var last_position = Vector2.ZERO

const MOVE_SPEED = 10000 * 1.6
const DASH_SPEED = 10000 * 4.0;
const DRIFT_INITIAL_SPEED = DASH_SPEED / 3.0;

const DASH_TIME = 0.04;
const DASH_EXIT_TIME = 0.05;
const DRIFTING_TIME = 0.20;

const SNAP_DISTANCE = 32.0
const SNAP_ANGLE = 20.0

var dashing_time = 0.0
var dash_exit_time = 0.0
var drift_time = 0.0

func _process(delta):
	if Input.is_action_pressed("dash") and alive and !won:
		dash_asked = true
		get_tree().call_group("camera", "camera_shake", 2.0, 2)

		if dash_status not in [DashStatus.DASHING, DashStatus.DASH_EXIT]:
			var puffle = Puffle.instantiate()
			get_tree().root.add_child(puffle)
			puffle.global_position = global_position

	# $DriftSmoke.emitting = dash_status == DashStatus.DRIFTING and (last_position.distance_to(position) > 5.0 * delta)

	shadow_delay_current -= delta

	if dash_status in [DashStatus.DASHING, DashStatus.DASH_EXIT, DashStatus.DRIFTING] and (last_position.distance_to(position) > 5.0 * delta):
		if shadow_delay_current < 0:
			shadow_delay_current = SHADOW_DELAY
			var shadow = Shadow.instantiate()
			shadow.rotation = rotation
			shadow.position = $AnimatedSprite2D.global_position
			get_node("/root/Game").add_child(shadow)

	#$DashParticles.process_material.set_shader_parameter("emission_angle", rotation_degrees)

	last_position = position
	look_at(transform.origin + direction)

	if velocity:
		$AnimatedSprite2D.play("move")
	else:
		$AnimatedSprite2D.play("idle")

	if iframe == 0 and !$Grounded.has_overlapping_bodies() and dash_status in [DashStatus.NONE, DashStatus.DRIFTING]:
		alive = false
		death_reason = "fall"

	iframe -= 1

	if iframe < 0:
		iframe = 0

func freeze():
	velocity = Vector2.ZERO
	drift = Vector2.ZERO
	direction = Vector2.ZERO
	dash_status = DashStatus.NONE

func _physics_process(delta):
	if !alive or won:
		velocity = Vector2.ZERO
		direction = Vector2.ZERO
		drift = Vector2.ZERO
		dash_status = DashStatus.NONE

	if dash_status not in [DashStatus.DASHING, DashStatus.DASH_EXIT] and alive and !won:
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
			$DashOut.play()

	# DASH
	if dash_status == DashStatus.DASHING:
		dashing_time -= delta

		var dir = Vector2.RIGHT.rotated(transform.get_rotation())
		velocity = dir.normalized() * DASH_SPEED * delta

		if dashing_time <= 0:
			dash_status = DashStatus.DASH_EXIT

	if dash_status in [DashStatus.DASHING, DashStatus.DASH_EXIT] and !$DashSlide.playing:
		$DashSlide.play()
	elif $DashSlide.playing and dash_status in [DashStatus.DRIFTING, DashStatus.NONE]:
		$DashSlide.stop()

	if dash_asked:
		dash_asked = false
		# if dash_status not in [DashStatus.DASHING, DashStatus.DASH_EXIT]:
		# 	$DashStart.play()
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
				velocity = velocity.rotated( - angle * 0.1)
				direction = direction.rotated( - angle * 0.1)
				drift = drift.rotated( - angle * 0.1)

	move_and_slide()

func hit():
	var was_alive = alive

	if alive:
		$Hit.play()
		death_reason = "hit"
		alive = false

	return was_alive

var won = false

func win():
	freeze()
	won = true
	var acc = Accumulator.instantiate()
	acc.position = position
	get_tree().root.add_child(acc)
