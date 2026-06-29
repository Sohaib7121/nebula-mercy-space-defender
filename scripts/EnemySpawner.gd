extends Node

signal enemy_spawned(enemy)

const EnemyScene = preload("res://scenes/Enemy.tscn")

var running := true
var _spawn_timer := 0.3
var _elapsed := 0.0
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()


func _process(delta: float) -> void:
	if not running:
		return

	_elapsed += delta
	_spawn_timer -= delta

	if _spawn_timer <= 0.0:
		_spawn_timer = _get_spawn_interval()
		_spawn_enemy()


func set_running(value: bool) -> void:
	running = value


func reset() -> void:
	running = true
	_spawn_timer = 0.3
	_elapsed = 0.0


func _spawn_enemy() -> void:
	var enemy = EnemyScene.instantiate()
	enemy.setup_enemy(_choose_enemy_type())

	var width := get_viewport().get_visible_rect().size.x
	enemy.position = Vector2(_rng.randf_range(72.0, width - 72.0), -90.0)
	enemy_spawned.emit(enemy)


func _get_spawn_interval() -> float:
	return maxf(0.45, 1.35 - (_elapsed * 0.018))


func _choose_enemy_type() -> String:
	var roll: float = _rng.randf()
	var tank_chance: float = minf(0.28, 0.04 + _elapsed * 0.002)
	var fast_chance: float = minf(0.38, 0.18 + _elapsed * 0.002)

	if roll < tank_chance:
		return "tank"
	if roll < tank_chance + fast_chance:
		return "fast"
	return "basic"
