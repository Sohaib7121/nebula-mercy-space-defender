extends Control

const GameScene = preload("res://scenes/Game.tscn")
const StarfieldScript = preload("res://scripts/Starfield.gd")

var _modal_overlay: ColorRect
var _modal_title: Label
var _modal_body: Label


func _ready() -> void:
	_build_background()
	_build_menu()
	_build_modal()


func _build_background() -> void:
	var starfield := Node2D.new()
	starfield.set_script(StarfieldScript)
	add_child(starfield)


func _build_menu() -> void:
	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 72)
	margin.add_theme_constant_override("margin_right", 72)
	margin.add_theme_constant_override("margin_top", 130)
	margin.add_theme_constant_override("margin_bottom", 130)
	add_child(margin)

	var layout := VBoxContainer.new()
	layout.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layout.alignment = BoxContainer.ALIGNMENT_CENTER
	layout.add_theme_constant_override("separation", 30)
	margin.add_child(layout)

	var title := Label.new()
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	title.text = "Nebula Mercy"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 86)
	layout.add_child(title)

	var subtitle := Label.new()
	subtitle.mouse_filter = Control.MOUSE_FILTER_IGNORE
	subtitle.text = "Free for everyone. No ads. No in-app purchases."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.add_theme_font_size_override("font_size", 34)
	layout.add_child(subtitle)

	layout.add_child(_make_spacer(70))
	layout.add_child(_make_button("Play", _on_play_pressed))
	layout.add_child(_make_button("How to Play", _on_how_to_play_pressed))
	layout.add_child(_make_button("Credits", _on_credits_pressed))
	layout.add_child(_make_button("Exit", _on_exit_pressed))

	var note := Label.new()
	note.mouse_filter = Control.MOUSE_FILTER_IGNORE
	note.text = "Original student project. Offline-first."
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	note.add_theme_font_size_override("font_size", 28)
	layout.add_child(note)


func _build_modal() -> void:
	_modal_overlay = ColorRect.new()
	_modal_overlay.color = Color(0.0, 0.0, 0.0, 0.82)
	_modal_overlay.visible = false
	_modal_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_modal_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_modal_overlay)

	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 72)
	margin.add_theme_constant_override("margin_right", 72)
	margin.add_theme_constant_override("margin_top", 180)
	margin.add_theme_constant_override("margin_bottom", 180)
	_modal_overlay.add_child(margin)

	var layout := VBoxContainer.new()
	layout.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layout.alignment = BoxContainer.ALIGNMENT_CENTER
	layout.add_theme_constant_override("separation", 42)
	margin.add_child(layout)

	_modal_title = Label.new()
	_modal_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_modal_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_modal_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_modal_title.add_theme_font_size_override("font_size", 58)
	layout.add_child(_modal_title)

	_modal_body = Label.new()
	_modal_body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_modal_body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_modal_body.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_modal_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_modal_body.add_theme_font_size_override("font_size", 34)
	_modal_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_modal_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(_modal_body)

	var ok_button := _make_button("OK", _hide_modal)
	ok_button.custom_minimum_size = Vector2(0, 112)
	layout.add_child(ok_button)


func _make_button(text: String, callback: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 92)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 34)
	button.pressed.connect(callback)
	return button


func _make_spacer(height: float) -> Control:
	var spacer := Control.new()
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	spacer.custom_minimum_size = Vector2(0, height)
	return spacer


func _on_play_pressed() -> void:
	AudioManager.play_button()
	get_tree().change_scene_to_packed(GameScene)


func _on_how_to_play_pressed() -> void:
	AudioManager.play_button()
	_show_modal(
		"How to Play",
		"Touch and drag anywhere in the lower half of the screen to move your ship. Shooting is automatic. Avoid drones, collect repair, double-shot, and shield pickups, and survive as long as you can."
	)


func _on_credits_pressed() -> void:
	AudioManager.play_button()
	_show_modal(
		"Credits",
		"Original student project made with Godot 4.x, GDScript, code-drawn shapes, particles, and generated placeholder tones. No paid assets, ads, cloud services, or copyrighted game art are used."
	)


func _on_exit_pressed() -> void:
	AudioManager.play_button()
	if OS.has_feature("mobile"):
		return

	get_tree().quit()


func _show_modal(title: String, body: String) -> void:
	_modal_title.text = title
	_modal_body.text = body
	_modal_overlay.visible = true


func _hide_modal() -> void:
	AudioManager.play_button()
	_modal_overlay.visible = false
