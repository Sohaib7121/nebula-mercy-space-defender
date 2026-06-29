extends Area2D

signal destroyed(enemy, score_value)
signal hit_player(enemy)
signal reached_bottom(enemy)

const ENEMY_TYPES = {
	"basic": {
		"speed": 235.0,
		"health": 1,
		"score": 100,
		"color": Color("#ff7f73"),
		"radius": 42.0,
	},
	"fast": {
		"speed": 390.0,
		"health": 1,
		"score": 150,
		"color": Color("#f8d66d"),
		"radius": 34.0,
	},
	"tank": {
		"speed": 170.0,
		"health": 3,
		"score": 280,
		"color": Color("#9b8cff"),
		"radius": 54.0,
	},
}

var enemy_type := "basic"
var health := 1
var speed := 235.0
var score_value := 100
var _base_color := Color("#ff7f73")
var _visual: Polygon2D
var _collision_shape: CollisionShape2D


func _ready() -> void:
	add_to_group("enemy")
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	_build_collision()
	_build_visual()
	_apply_enemy_type()


func setup_enemy(new_type: String) -> void:
	enemy_type = new_type
	if is_node_ready():
		_apply_enemy_type()


func _process(delta: float) -> void:
	position.y += speed * delta

	if position.y > get_viewport_rect().size.y + 90.0:
		reached_bottom.emit(self)
		queue_free()


func take_damage(amount: int) -> void:
	health -= amount
	_flash_hit()

	if health <= 0:
		destroyed.emit(self, score_value)
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("player_bullet"):
		return

	if area.has_method("mark_hit"):
		area.mark_hit()

	take_damage(int(area.get("damage")))


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		hit_player.emit(self)
		queue_free()


func _apply_enemy_type() -> void:
	var data: Dictionary = ENEMY_TYPES.get(enemy_type, ENEMY_TYPES["basic"])
	speed = float(data["speed"])
	health = int(data["health"])
	score_value = int(data["score"])
	_base_color = data["color"]

	if _visual != null:
		_visual.color = _base_color
	if _collision_shape != null:
		var shape := CircleShape2D.new()
		shape.radius = float(data["radius"])
		_collision_shape.shape = shape


func _build_collision() -> void:
	_collision_shape = CollisionShape2D.new()
	add_child(_collision_shape)


func _build_visual() -> void:
	_visual = Polygon2D.new()
	_visual.polygon = PackedVector2Array([
		Vector2(0, -54),
		Vector2(48, -16),
		Vector2(36, 40),
		Vector2(0, 60),
		Vector2(-36, 40),
		Vector2(-48, -16),
	])
	add_child(_visual)

	var eye := Polygon2D.new()
	eye.polygon = PackedVector2Array([
		Vector2(0, -20),
		Vector2(22, 0),
		Vector2(0, 18),
		Vector2(-22, 0),
	])
	eye.color = Color("#111827")
	add_child(eye)


func _flash_hit() -> void:
	if _visual == null:
		return

	_visual.color = Color.WHITE
	var tween := create_tween()
	tween.tween_property(_visual, "color", _base_color, 0.08)
