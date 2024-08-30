# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2023 MizunagiKB <mizukb@live.jp>
extends Control

# Constants for rendering settings
const MIX_RENDER_SIZE := 32
const MAX_RENDER_SIZE := 2048
const RENDER_SIZE_STEP := 256
const ENABLE_MOTION_FINISHED := true

# Variables for Cubism model and parameters
var cubism_model: GDCubismUserModel
var ary_param: Array
var last_motion = null  # Keeps track of the last motion played

# Function to set up the Cubism model with the given pathname
func setup(pathname: String):
	cubism_model.assets = pathname  # Set the assets for the model

	# Retrieve canvas information for the model
	var canvas_info = cubism_model.get_canvas_info()

	# Initialize motion list in the UI
	var idx: int = 0
	var dict_motion = cubism_model.get_motions()
	$UI/ItemListMotion.clear()  # Clear the current list of motions
	for k in dict_motion:
		for v in range(dict_motion[k]):
			$UI/ItemListMotion.add_item("{0}_{1}".format([k, v]))  # Add motion items to the UI list
			$UI/ItemListMotion.set_item_metadata(idx, {"group": k, "no": v})  # Store metadata for motion selection
			idx += 1

	# Initialize expression list in the UI
	$UI/ItemListExpression.clear()
	for item in cubism_model.get_expressions():
		$UI/ItemListExpression.add_item(item)  # Add expression items to the UI list

	# Set the model to idle mode and assign its texture to a Sprite2D node
	cubism_model.playback_process_mode = GDCubismUserModel.IDLE
	$Sprite2D.texture = cubism_model.get_texture()

	# Create and set a material for the Sprite2D node
	var mat = CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_PREMULT_ALPHA
	mat.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	$Sprite2D.material = mat

# Recursive function to search for `.model3.json` files in a directory and its subdirectories
func model3_search(dirname: String):
	var dir: DirAccess = DirAccess.open(dirname)
	if dir == null:
		return  # Exit if directory cannot be opened

	dir.list_dir_begin()
	var name = dir.get_next()
	while name != "":
		if dir.current_is_dir():
			model3_search(dirname.path_join(name))  # Recursively search in subdirectories
		else:
			if name.ends_with(".model3.json"):
				print(dirname.path_join(name))  # Print the path of the found model file
				$UI/OptModel.add_item(dirname.path_join(name))  # Add the model to the UI option list
		name = dir.get_next()

# Ready function that initializes the Cubism model and UI elements when the node is added to the scene
func _ready():
	cubism_model = GDCubismUserModel.new()  # Create a new Cubism model instance
	if ENABLE_MOTION_FINISHED == true:
		cubism_model.motion_finished.connect(_on_motion_finished)  # Connect the motion finished signal to a handler
	$Sprite2D.add_child(cubism_model)  # Add the model as a child to the Sprite2D node

	# Initialize the model selection UI
	$UI/OptModel.clear()
	$UI/OptModel.add_item("")  # Add an empty item as the default
	model3_search("res://addons/gd_cubism/example/res/live2d")  # Search for models in the specified directory

# Process function that runs every frame to adjust the model's size and position based on the window size
func _process(delta):
	var vct_resolution = Vector2(get_window().size)  # Get the window size
	var texture_height = floor(vct_resolution.y / RENDER_SIZE_STEP) * RENDER_SIZE_STEP
	texture_height = clampi(texture_height, MIX_RENDER_SIZE, MAX_RENDER_SIZE)  # Clamp the texture size

	cubism_model.size = Vector2.ONE * texture_height  # Set the model size based on the window height

	var vct_viewport_size = Vector2(get_viewport_rect().size)
	$Sprite2D.position = vct_viewport_size / 2  # Center the model in the viewport
	$Sprite2D.scale.x = vct_viewport_size.y / cubism_model.size.y  # Scale the model to fit the viewport height
	$Sprite2D.scale.y = $Sprite2D.scale.x  # Maintain aspect ratio

# Function called when a motion finishes playing
func _on_motion_finished():
	cubism_model.start_motion(
		last_motion.group,
		last_motion.no,
		GDCubismUserModel.PRIORITY_FORCE
	)  # Restart the last motion that was played

# Function called when a model is selected from the UI dropdown
func _on_opt_model_item_selected(index):
	setup($UI/OptModel.get_item_text(index))  # Set up the selected model

# Function called when a motion is selected from the motion list
func _on_item_list_motion_item_selected(index):
	var motion = $UI/ItemListMotion.get_item_metadata(index)
	var m = cubism_model.start_motion(motion.group, motion.no, GDCubismUserModel.PRIORITY_FORCE)  # Start the selected motion
	last_motion = motion  # Store the motion as the last played

# Function called when an expression is selected from the expression list
func _on_item_list_expression_item_selected(index):
	var expression_id = $UI/ItemListExpression.get_item_text(index)
	cubism_model.start_expression(expression_id)  # Start the selected expression
