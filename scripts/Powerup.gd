extends Area2D

signal collected(powerup, powerup_type)

const FALL_SPEED = 250.0
const POWERUP_COLORS = {
	"health": Color("#7ee787"),
	"double": Color("#f8d66d"),
	"shield": Color("#6df7ff"),
}

var powerup_type := "health"
var _visual: Polygon2D


func _ready() -> void:
	add_to_group("powerup")
	body_entered.connect(_on_body_entered)
	_build_collision()
	_build_visual()
	_refresh_visual()


func setup(new_type: String) -> void:
	powerup_type = new_type
	if is_node_ready():
		_refresh_visual()


func _process(delta: float) -> void:
	position.y += FALL_SPEED * delta
	rotation += delta * 2.2

	if position.y > get_viewport_rect().size.y + 80.0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		collected.emit(self, powerup_type)
		queue_free()


func _build_collision() -> void:
	var collision_shape := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 34.0
	collision_shape.shape = shape
	add_child(collision_shape)


func _build_visual() -> void:
	_visual = Polygon2D.new()
	_visual.polygon = PackedVector2Array([
		Vector2(0, -42),
		Vector2(36, 0),
		Vector2(0, 42),
		Vector2(-36, 0),
	])
	add_child(_visual)

	var core := Polygon2D.new()
	core.polygon = PackedVector2Array([
		Vector2(0, -18),
		Vector2(16, 0),
		Vector2(0, 18),
		Vector2(-16, 0),
	])
	core.color = Color("#111827")
	add_child(core)


func _refresh_visual() -> void:
	if _visual == null:
		return

	_visual.color = POWERUP_COLORS.get(powerup_type, POWERUP_COLORS["health"])
