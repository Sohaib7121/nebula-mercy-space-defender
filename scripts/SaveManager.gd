extends Node

const SAVE_PATH = "user://nebula_mercy_save.cfg"
const SECTION = "scores"
const HIGH_SCORE_KEY = "high_score"

var high_score := 0


func _ready() -> void:
	load_game()


func load_game() -> void:
	var config := ConfigFile.new()
	var error := config.load(SAVE_PATH)

	if error == OK:
		high_score = int(config.get_value(SECTION, HIGH_SCORE_KEY, 0))
	else:
		high_score = 0


func get_high_score() -> int:
	return high_score


func set_high_score(value: int) -> void:
	if value <= high_score:
		return

	high_score = value
	save_game()


func save_game() -> void:
	var config := ConfigFile.new()
	config.set_value(SECTION, HIGH_SCORE_KEY, high_score)
	config.save(SAVE_PATH)
