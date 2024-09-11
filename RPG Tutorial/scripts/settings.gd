extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var total_sound_h_slider = $MarginContainer/settings_box/settings_container/total_sound/total_sound_h_slider
	Global.load_global_info()
	total_sound_h_slider.value = Global.global_info["sys"]["sound"]["total_sound"]

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
	var resolution_select_button = $MarginContainer/settings_box/settings_container/HBoxContainer4/resolution_select_button
	if index == 0:
		Global.global_info["sys"]["resolution"] = Vector2(1366, 768)
	elif index == 1: 
		Global.global_info["sys"]["resolution"] = Vector2(1920, 1080)
	elif index == 2:
		Global.global_info["sys"]["resolution"] = Vector2(2560, 1440)
	Global.save_global_info()
	get_tree().root.set_content_scale_size(Global.global_info["sys"]["resolution"])
