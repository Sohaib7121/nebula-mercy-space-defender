extends Node2D

const PlayerScene = preload("res://scenes/Player.tscn")
const BulletScene = preload("res://scenes/Bullet.tscn")
const EnemySpawnerScene = preload("res://scenes/EnemySpawner.tscn")
const GameManagerScene = preload("res://scenes/GameManager.tscn")
const UIManagerScene = preload("res://scenes/UIManager.tscn")
const PowerupScene = preload("res://scenes/Powerup.tscn")
const ExplosionScene = preload("res://scenes/Explosion.tscn")
const StarfieldScript = preload("res://scripts/Starfield.gd")

var _player
var _spawner
var _manager
var _ui
var _camera: Camera2D
var _shake_time := 0.0
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	get_tree().paused = false
	_rng.randomize()
	_build_world()
	_connect_game()
	_manager.start_new_game()


func _process(delta: float) -> void:
	_update_camera_shake(delta)


func _build_world() -> void:
	var starfield := Node2D.new()
	starfield.set_script(StarfieldScript)
	add_child(starfield)

	_camera = Camera2D.new()
	_camera.enabled = true
	_camera.position = get_viewport_rect().size * 0.5
	add_child(_camera)

	_manager = GameManagerScene.instantiate()
	add_child(_manager)

	_player = PlayerScene.instantiate()
	_player.global_position = Vector2(get_viewport_rect().size.x * 0.5, get_viewport_rect().size.y - 230.0)
	add_child(_player)

	_spawner = EnemySpawnerScene.instantiate()
	add_child(_spawner)

	_ui = UIManagerScene.instantiate()
	add_child(_ui)


func _connect_game() -> void:
	_player.fire_requested.connect(_on_player_fire_requested)
	_spawner.enemy_spawned.connect(_on_enemy_spawned)

	_manager.score_changed.connect(_ui.set_score)
	_manager.high_score_changed.connect(_ui.set_high_score)
	_manager.health_changed.connect(_ui.set_health)
	_manager.pause_changed.connect(_ui.set_paused)
	_manager.game_over.connect(_on_game_over)

	_ui.restart_requested.connect(_restart_game)
	_ui.menu_requested.connect(_go_to_main_menu)
	_ui.pause_requested.connect(_toggle_pause)


func _on_player_fire_requested(muzzle_positions: Array) -> void:
	for muzzle_position in muzzle_positions:
		var bullet = BulletScene.instantiate()
		bullet.global_position = muzzle_position
		add_child(bullet)

	AudioManager.play_shoot()


func _on_enemy_spawned(enemy) -> void:
	add_child(enemy)
	enemy.destroyed.connect(_on_enemy_destroyed)
	enemy.hit_player.connect(_on_enemy_hit_player)
	enemy.reached_bottom.connect(_on_enemy_reached_bottom)


func _on_enemy_destroyed(enemy, score_value: int) -> void:
	var burst_position: Vector2 = enemy.global_position
	_manager.add_score(score_value)
	_spawn_explosion(burst_position, Color("#ff7f73"))
	_maybe_spawn_powerup(burst_position)
	AudioManager.play_explosion()


func _on_enemy_hit_player(enemy) -> void:
	var burst_position: Vector2 = enemy.global_position
	_spawn_explosion(burst_position, Color("#ff7f73"))

	if _player.has_shield():
		_player.flash_shield()
		AudioManager.play_hit()
		return

	_manager.damage_player(1)
	_player.show_damage_feedback()
	_shake_time = 0.18
	AudioManager.play_hit()


func _on_enemy_reached_bottom(enemy) -> void:
	_manager.damage_player(1)
	_shake_time = 0.22
	_spawn_explosion(Vector2(enemy.global_position.x, get_viewport_rect().size.y - 60.0), Color("#9b8cff"))
	AudioManager.play_hit()


func _maybe_spawn_powerup(spawn_position: Vector2) -> void:
	if _rng.randf() > 0.16:
		return

	var powerup = PowerupScene.instantiate()
	var types := ["health", "double", "shield"]
	powerup.setup(types[_rng.randi_range(0, types.size() - 1)])
	powerup.global_position = spawn_position
	powerup.collected.connect(_on_powerup_collected)
	call_deferred("add_child", powerup)


func _on_powerup_collected(_powerup, powerup_type: String) -> void:
	match powerup_type:
		"health":
			_manager.heal_player(1)
		"double":
			_player.set_double_shot(8.0)
		"shield":
			_player.set_shield(5.0)

	AudioManager.play_powerup()


func _on_game_over(final_score: int) -> void:
	_spawner.set_running(false)
	_player.set_active(false)
	_ui.show_game_over(final_score, _manager.high_score)
	AudioManager.play_game_over()


func _toggle_pause() -> void:
	_manager.set_paused(not get_tree().paused)


func _restart_game() -> void:
	get_tree().paused = false
	AudioManager.play_button()
	get_tree().reload_current_scene()


func _go_to_main_menu() -> void:
	get_tree().paused = false
	AudioManager.play_button()
	call_deferred("_change_to_main_menu")


func _change_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func _spawn_explosion(spawn_position: Vector2, color: Color) -> void:
	var explosion = ExplosionScene.instantiate()
	explosion.global_position = spawn_position
	add_child(explosion)
	explosion.burst(color)


func _update_camera_shake(delta: float) -> void:
	if _camera == null:
		return

	if _shake_time <= 0.0:
		_camera.offset = Vector2.ZERO
		return

	_shake_time -= delta
	_camera.offset = Vector2(
		_rng.randf_range(-14.0, 14.0),
		_rng.randf_range(-14.0, 14.0)
	)
