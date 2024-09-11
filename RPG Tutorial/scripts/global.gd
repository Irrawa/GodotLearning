extends Node

var global_info = {
	"sys": {
		"sound": {
			"total_sound": 50, 
			"bg_sound": 50,
			"se_sound": 50,
		},
		"resolution" : Vector2(1920, 1080),
		"full_screen": false
	},
	"player": {
		
	}
}


func save_global_info() -> void:
	var file = FileAccess.open("user://global_info.dat", FileAccess.WRITE)
	file.store_var(global_info)

func load_global_info() -> void:
	var file = FileAccess.open("user://global_info.dat", FileAccess.READ)
	if file:
		var loaded_global_info = file.get_var()
		global_info = loaded_global_info
	save_global_info()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_global_info()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
