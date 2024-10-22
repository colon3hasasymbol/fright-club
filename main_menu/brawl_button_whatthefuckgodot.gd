extends TextureButton


const BRAWL_MENU = preload("res://brawl_menu/brawl_menu.tscn")


func _on_button_up() -> void:
	if !$/root/Main.has_node("BrawlMenu"):
		var brawl_menu = BRAWL_MENU.instantiate()
		$/root/Main.add_child(brawl_menu)
		brawl_menu.slide()
