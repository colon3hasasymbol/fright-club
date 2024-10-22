extends TextureButton


const MAIN_MENU = preload("res://main_menu/main_menu.tscn")
const BRAWL_MENU = preload("res://brawl_menu/brawl_menu.tscn")


func _on_button_up() -> void:
	var main_menu = MAIN_MENU.instantiate()
	if $"../NewRunButton".was_lost_game_brawl:
		var brawl_menu = BRAWL_MENU.instantiate()
		brawl_menu.autoslide = false
		$/root/Main.add_child(brawl_menu)
	main_menu.autoslide = false
	$/root/Main.add_child(main_menu)
	var node = $"../../.."
	node.slide_reversed()
	await node.finished_reverse
	node.queue_free()
