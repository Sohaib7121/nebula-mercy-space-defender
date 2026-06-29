extends Area2D

const SPEED = 1320.0

var damage := 1


func _ready() -> void:
	add_to_group("player_bullet")
	_build_collision()
	_build_visual()


func _process(delta: float) -> void:
	position.y -= SPEED * delta
	if position.y < -80.0:
		queue_free()


func mark_hit() -> void:
	queue_free()


func _build_collision() -> void:
	var collision_shape := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 15.0
	collision_shape.shape = shape
	add_child(collision_shape)


func _build_visual() -> void:
	var bolt := Polygon2D.new()
	bolt.polygon = PackedVector2Array([
		Vector2(0, -26),
		Vector2(11, -4),
		Vector2(5, 24),
		Vector2(-5, 24),
		Vector2(-11, -4),
	])
	bolt.color = Color("#f8d66d")
	add_child(bolt)
