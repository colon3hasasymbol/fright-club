extends TextureRect

func _ready():
	update_scale()

func _resized():
	update_scale()

func update_scale():
	# Make sure the texture is loaded
	if texture:
		# Calculate scale factor to make the size 3x3 pixels
		var texture_size = texture.get_size()
		var scale_factor_x = 3.0 / texture_size.x
		var scale_factor_y = 3.0 / texture_size.y
		
		# Set the scale of the TextureRect
		scale = Vector2(scale_factor_x, scale_factor_y)
		print(scale)
