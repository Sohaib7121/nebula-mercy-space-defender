extends Node

# This manager creates tiny tone effects in code, so the MVP needs no paid or
# downloaded audio files. Replace these later with CC0 sounds if you want.

var muted := false
var _sounds := {}
var _sample_rate := 22050.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_create_tone("shoot", 760.0, 0.055, 0.17)
	_create_tone("hit", 150.0, 0.12, 0.22)
	_create_tone("explosion", 92.0, 0.22, 0.25)
	_create_tone("powerup", 1040.0, 0.16, 0.2)
	_create_tone("button", 520.0, 0.08, 0.14)
	_create_tone("game_over", 72.0, 0.45, 0.22)


func toggle_mute() -> bool:
	muted = not muted
	return muted


func set_muted(value: bool) -> void:
	muted = value


func play_shoot() -> void:
	_play_tone("shoot")


func play_hit() -> void:
	_play_tone("hit")


func play_explosion() -> void:
	_play_tone("explosion")


func play_powerup() -> void:
	_play_tone("powerup")


func play_button() -> void:
	_play_tone("button")


func play_game_over() -> void:
	_play_tone("game_over")


func _create_tone(key: String, frequency: float, duration: float, volume: float) -> void:
	var stream := AudioStreamGenerator.new()
	stream.mix_rate = _sample_rate
	stream.buffer_length = max(duration + 0.05, 0.12)

	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = linear_to_db(volume)
	add_child(player)

	_sounds[key] = {
		"player": player,
		"frequency": frequency,
		"duration": duration,
	}


func _play_tone(key: String) -> void:
	if muted or not _sounds.has(key):
		return

	var data: Dictionary = _sounds[key]
	var player: AudioStreamPlayer = data["player"]
	var frequency := float(data["frequency"])
	var duration := float(data["duration"])

	player.stop()
	player.play()

	var playback := player.get_stream_playback() as AudioStreamGeneratorPlayback
	if playback == null:
		return

	var frames := int(_sample_rate * duration)
	for i in range(frames):
		var progress := float(i) / float(frames)
		var envelope := 1.0 - progress
		var wave := sin(progress * duration * frequency * TAU)
		var sample := wave * envelope * 0.55
		playback.push_frame(Vector2(sample, sample))
