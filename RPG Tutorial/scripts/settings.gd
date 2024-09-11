extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.load_global_info()
	
	var total_sound_h_slider = $MarginContainer/settings_box/settings_container/total_sound/total_sound_h_slider
	total_sound_h_slider.value = Global.global_info["sys"]["sound"]["total_sound"]
	
	var fullscreen_switch_button = $MarginContainer/settings_box/settings_container/HBoxContainer4/fullscreen_switch_button
	fullscreen_switch_button.button_pressed = Global.global_info["sys"]["full_screen"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_total_sound_h_slider_drag_ended(value_changed: bool) -> void:
	var total_sound_h_slider = $MarginContainer/settings_box/settings_container/total_sound/total_sound_h_slider
	if value_changed:
		Global.global_info["sys"]["sound"]["total_sound"] = total_sound_h_slider.value
		Global.save_global_info()

func _on_option_button_item_selected(index: int) -> void:
	# 0: 1366*768;   1: 1920*1080;   2:2560*1440
	if index == 0:
		Global.global_info["sys"]["resolution"] = Vector2(1366, 768)
	elif index == 1: 
		Global.global_info["sys"]["resolution"] = Vector2(1920, 1080)
	elif index == 2:
		Global.global_info["sys"]["resolution"] = Vector2(2560, 1440)
	Global.save_global_info()
	get_tree().root.set_content_scale_size(Global.global_info["sys"]["resolution"])


func _on_fullscreen_switch_button_toggled(toggled_on: bool) -> void:
	var fullscreen_switch_button = $MarginContainer/settings_box/settings_container/HBoxContainer4/fullscreen_switch_button
	Global.global_info["sys"]["full_screen"] = toggled_on
	Global.save_global_info()
	if not Global.global_info["sys"]["full_screen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
