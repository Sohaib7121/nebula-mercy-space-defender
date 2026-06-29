extends Node2D

@export var star_count := 150
@export var base_speed := 110.0

var _stars: Array[Dictionary] = []
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()
	z_index = -100
	_create_stars()


func _process(delta: float) -> void:
	var size := get_viewport_rect().size
	for star in _stars:
		var star_position: Vector2 = star["position"]
		star_position.y += float(star["speed"]) * delta
		if star_position.y > size.y + 12.0:
			star_position = Vector2(_rng.randf_range(0.0, size.x), -12.0)
		star["position"] = star_position
	queue_redraw()


func _draw() -> void:
	var size := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, size), Color("#07111f"))

	for star in _stars:
		var alpha := float(star["alpha"])
		draw_circle(star["position"], float(star["radius"]), Color(1.0, 1.0, 1.0, alpha))


func _create_stars() -> void:
	var size := get_viewport_rect().size
	_stars.clear()

	for i in range(star_count):
		var depth := _rng.randf_range(0.35, 1.0)
		_stars.append({
			"position": Vector2(_rng.randf_range(0.0, size.x), _rng.randf_range(0.0, size.y)),
			"radius": _rng.randf_range(1.2, 3.8) * depth,
			"speed": base_speed * depth,
			"alpha": _rng.randf_range(0.35, 0.92),
		})
