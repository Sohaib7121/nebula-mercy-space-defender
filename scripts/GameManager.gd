extends Node

signal score_changed(score)
signal high_score_changed(high_score)
signal health_changed(current_health, max_health)
signal game_over(final_score)
signal pause_changed(paused)

const MAX_HEALTH = 3

var score := 0
var high_score := 0
var health := MAX_HEALTH
var is_game_over := false
var is_paused := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func start_new_game() -> void:
	score = 0
	health = MAX_HEALTH
	is_game_over = false
	is_paused = false
	high_score = SaveManager.get_high_score()

	score_changed.emit(score)
	high_score_changed.emit(high_score)
	health_changed.emit(health, MAX_HEALTH)
	pause_changed.emit(false)


func add_score(amount: int) -> void:
	if is_game_over:
		return

	score += amount
	score_changed.emit(score)

	if score > high_score:
		high_score = score
		SaveManager.set_high_score(high_score)
		high_score_changed.emit(high_score)


func heal_player(amount: int) -> void:
	if is_game_over:
		return

	health = min(MAX_HEALTH, health + amount)
	health_changed.emit(health, MAX_HEALTH)


func damage_player(amount: int) -> void:
	if is_game_over:
		return

	health = max(0, health - amount)
	health_changed.emit(health, MAX_HEALTH)

	if health <= 0:
		_end_game()


func set_paused(value: bool) -> void:
	if is_game_over:
		return

	is_paused = value
	get_tree().paused = value
	pause_changed.emit(is_paused)


func _end_game() -> void:
	is_game_over = true
	get_tree().paused = false
	game_over.emit(score)
