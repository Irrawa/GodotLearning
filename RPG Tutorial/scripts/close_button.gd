extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_up() -> void:
	var parent = self.get_parent()
	var g_parent = parent.get_parent()
	if g_parent:
		g_parent.call_deferred("remove_child", parent)
