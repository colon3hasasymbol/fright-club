extends TextureButton


const SETTINGS_MENU = preload("res://settings_menu/settings_menu.tscn")


func _on_button_up() -> void:
	var settings_menu = SETTINGS_MENU.instantiate()
	$/root/Main.add_child(settings_menu)
