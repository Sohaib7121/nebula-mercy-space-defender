extends CharacterBody2D

signal fire_requested(muzzle_positions)

const MOVE_SPEED = 880.0
const TOUCH_FOLLOW_SPEED = 14.0
const FIRE_INTERVAL = 0.25
const LOWER_SCREEN_LIMIT = 0.42

var _screen_size := Vector2.ZERO
var _fire_timer := 0.0
var _active := true
var _touch_active := false
var _touch_target := Vector2.ZERO
var _double_shot_time := 0.0
var _shield_time := 0.0
var _body_shape: Polygon2D
var _shield_ring: Line2D


func _ready() -> void:
	add_to_group("player")
	_screen_size = get_viewport_rect().size
	_touch_target = global_position
	_build_collision()
	_build_visuals()


func _physics_process(delta: float) -> void:
	if not _active:
		return

	_update_powerup_timers(delta)
	_move_player(delta)
	_fire_timer -= delta

	if _fire_timer <= 0.0:
		_fire_timer = FIRE_INTERVAL
		fire_requested.emit(_get_muzzle_positions())


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_touch_active = event.pressed
		_touch_target = event.position
	elif event is InputEventScreenDrag:
		_touch_active = true
		_touch_target = event.position
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_touch_active = event.pressed
		_touch_target = event.position
	elif event is InputEventMouseMotion and _touch_active:
		_touch_target = event.position


func set_active(value: bool) -> void:
	_active = value


func set_double_shot(duration: float) -> void:
	_double_shot_time = max(_double_shot_time, duration)


func set_shield(duration: float) -> void:
	_shield_time = max(_shield_time, duration)
	_shield_ring.visible = true


func has_shield() -> bool:
	return _shield_time > 0.0


func show_damage_feedback() -> void:
	if _body_shape == null:
		return

	_body_shape.modulate = Color("#ff7f73")
	var tween := create_tween()
	tween.tween_property(_body_shape, "modulate", Color.WHITE, 0.14)


func flash_shield() -> void:
	if _shield_ring == null:
		return

	_shield_ring.default_color = Color("#ffffff")
	var tween := create_tween()
	tween.tween_property(_shield_ring, "default_color", Color("#6df7ff"), 0.12)


func _move_player(delta: float) -> void:
	var input_vector := Vector2.ZERO

	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		input_vector.x -= 1.0
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		input_vector.x += 1.0
	if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
		input_vector.y -= 1.0
	if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
		input_vector.y += 1.0

	if input_vector.length() > 0.0:
		velocity = input_vector.normalized() * MOVE_SPEED
		move_and_slide()
	elif _touch_active:
		global_position = global_position.lerp(_clamp_to_play_area(_touch_target), min(1.0, TOUCH_FOLLOW_SPEED * delta))
		velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO

	global_position = _clamp_to_play_area(global_position)


func _clamp_to_play_area(value: Vector2) -> Vector2:
	return Vector2(
		clamp(value.x, 60.0, _screen_size.x - 60.0),
		clamp(value.y, _screen_size.y * LOWER_SCREEN_LIMIT, _screen_size.y - 110.0)
	)


func _get_muzzle_positions() -> Array:
	if _double_shot_time > 0.0:
		return [
			global_position + Vector2(-34.0, -58.0),
			global_position + Vector2(34.0, -58.0),
		]

	return [global_position + Vector2(0.0, -66.0)]


func _update_powerup_timers(delta: float) -> void:
	_double_shot_time = max(0.0, _double_shot_time - delta)
	_shield_time = max(0.0, _shield_time - delta)
	_shield_ring.visible = _shield_time > 0.0


func _build_collision() -> void:
	var collision_shape := CollisionShape2D.new()
	var shape := CapsuleShape2D.new()
	shape.radius = 34.0
	shape.height = 88.0
	collision_shape.shape = shape
	add_child(collision_shape)


func _build_visuals() -> void:
	_body_shape = Polygon2D.new()
	_body_shape.polygon = PackedVector2Array([
		Vector2(0, -72),
		Vector2(42, 34),
		Vector2(18, 24),
		Vector2(0, 64),
		Vector2(-18, 24),
		Vector2(-42, 34),
	])
	_body_shape.color = Color("#6df7ff")
	add_child(_body_shape)

	var cockpit := Polygon2D.new()
	cockpit.polygon = PackedVector2Array([
		Vector2(0, -38),
		Vector2(18, 6),
		Vector2(0, 22),
		Vector2(-18, 6),
	])
	cockpit.color = Color("#17233d")
	add_child(cockpit)

	var engine := Polygon2D.new()
	engine.polygon = PackedVector2Array([
		Vector2(-14, 46),
		Vector2(0, 82),
		Vector2(14, 46),
	])
	engine.color = Color("#f8d66d")
	add_child(engine)

	_shield_ring = Line2D.new()
	_shield_ring.width = 7.0
	_shield_ring.default_color = Color("#6df7ff")
	_shield_ring.closed = true
	_shield_ring.points = _make_circle_points(70.0, 36)
	_shield_ring.visible = false
	add_child(_shield_ring)


func _make_circle_points(radius: float, steps: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i in range(steps):
		var angle := TAU * float(i) / float(steps)
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	return points
