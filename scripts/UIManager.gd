extends CanvasLayer

signal restart_requested
signal menu_requested
signal pause_requested

var _score_label: Label
var _high_score_label: Label
var _health_label: Label
var _pause_button: Button
var _mute_button: Button
var _pause_label: Label
var _game_over_overlay: ColorRect
var _final_score_label: Label
var _game_over_action_locked := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_hud()
	_build_pause_label()
	_build_game_over()


func set_score(value: int) -> void:
	_score_label.text = "Score: %d" % value


func set_high_score(value: int) -> void:
	_high_score_label.text = "Best: %d" % value


func set_health(current: int, maximum: int) -> void:
	_health_label.text = "HP: %d/%d" % [current, maximum]


func set_paused(paused: bool) -> void:
	_pause_button.text = "Resume" if paused else "Pause"
	_pause_label.visible = paused


func show_game_over(final_score: int, high_score: int) -> void:
	_game_over_action_locked = false
	_pause_label.visible = false
	_game_over_overlay.visible = true
	_final_score_label.text = "Final Score: %d\nBest Score: %d" % [final_score, high_score]


func _build_hud() -> void:
	var root := Control.new()
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(root)

	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 28)
	margin.add_theme_constant_override("margin_right", 28)
	margin.add_theme_constant_override("margin_top", 28)
	margin.add_theme_constant_override("margin_bottom", 28)
	root.add_child(margin)

	var layout := VBoxContainer.new()
	layout.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layout.add_theme_constant_override("separation", 18)
	margin.add_child(layout)

	var top_bar := HBoxContainer.new()
	top_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_bar.custom_minimum_size = Vector2(0, 92)
	top_bar.add_theme_constant_override("separation", 18)
	layout.add_child(top_bar)

	_score_label = _make_label("Score: 0", 30)
	top_bar.add_child(_score_label)

	_high_score_label = _make_label("Best: 0", 30)
	top_bar.add_child(_high_score_label)

	_health_label = _make_label("HP: 3/3", 30)
	top_bar.add_child(_health_label)

	var spacer := Control.new()
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_bar.add_child(spacer)

	_mute_button = _make_small_button("Mute")
	_mute_button.pressed.connect(_on_mute_pressed)
	top_bar.add_child(_mute_button)

	_pause_button = _make_small_button("Pause")
	_pause_button.pressed.connect(_on_pause_pressed)
	top_bar.add_child(_pause_button)


func _build_pause_label() -> void:
	_pause_label = Label.new()
	_pause_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_pause_label.text = "Paused"
	_pause_label.visible = false
	_pause_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_pause_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_pause_label.add_theme_font_size_override("font_size", 72)
	_pause_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_pause_label)


func _build_game_over() -> void:
	_game_over_overlay = ColorRect.new()
	_game_over_overlay.color = Color(0.0, 0.0, 0.0, 0.78)
	_game_over_overlay.visible = false
	_game_over_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_game_over_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_game_over_overlay)

	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 90)
	margin.add_theme_constant_override("margin_right", 90)
	margin.add_theme_constant_override("margin_top", 260)
	margin.add_theme_constant_override("margin_bottom", 260)
	_game_over_overlay.add_child(margin)

	var layout := VBoxContainer.new()
	layout.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layout.alignment = BoxContainer.ALIGNMENT_CENTER
	layout.add_theme_constant_override("separation", 46)
	margin.add_child(layout)

	var title := Label.new()
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	title.text = "Game Over"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 78)
	layout.add_child(title)

	_final_score_label = Label.new()
	_final_score_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_final_score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_final_score_label.add_theme_font_size_override("font_size", 38)
	layout.add_child(_final_score_label)

	var restart_button := _make_large_button("Restart")
	restart_button.button_down.connect(_on_restart_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	layout.add_child(restart_button)

	var menu_button := _make_large_button("Main Menu")
	menu_button.button_down.connect(_on_menu_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	layout.add_child(menu_button)


func _make_label(text: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	return label


func _make_small_button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(140, 78)
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 25)
	return button


func _make_large_button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 128)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 38)
	return button


func _on_pause_pressed() -> void:
	AudioManager.play_button()
	pause_requested.emit()


func _on_mute_pressed() -> void:
	var is_muted: bool = AudioManager.toggle_mute()
	_mute_button.text = "Sound" if is_muted else "Mute"


func _on_restart_pressed() -> void:
	if _game_over_action_locked:
		return

	_game_over_action_locked = true
	AudioManager.play_button()
	restart_requested.emit()


func _on_menu_pressed() -> void:
	if _game_over_action_locked:
		return

	_game_over_action_locked = true
	AudioManager.play_button()
	menu_requested.emit()
