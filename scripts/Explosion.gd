extends Node2D

var _particles: Array[Dictionary] = []
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()


func burst(color: Color, amount: int = 22) -> void:
	_particles.clear()

	for i in range(amount):
		var angle := _rng.randf_range(0.0, TAU)
		var speed := _rng.randf_range(120.0, 520.0)
		_particles.append({
			"position": Vector2.ZERO,
			"velocity": Vector2(cos(angle), sin(angle)) * speed,
			"life": _rng.randf_range(0.28, 0.58),
			"max_life": 0.58,
			"radius": _rng.randf_range(4.0, 12.0),
			"color": color,
		})


func _process(delta: float) -> void:
	for i in range(_particles.size() - 1, -1, -1):
		var particle: Dictionary = _particles[i]
		particle["life"] = float(particle["life"]) - delta
		var particle_position: Vector2 = particle["position"]
		particle_position += particle["velocity"] * delta
		particle["position"] = particle_position

		if float(particle["life"]) <= 0.0:
			_particles.remove_at(i)
		else:
			_particles[i] = particle

	if _particles.is_empty():
		queue_free()

	queue_redraw()


func _draw() -> void:
	for particle in _particles:
		var life := float(particle["life"])
		var max_life := float(particle["max_life"])
		var color: Color = particle["color"]
		color.a = clamp(life / max_life, 0.0, 1.0)
		draw_circle(particle["position"], float(particle["radius"]), color)
