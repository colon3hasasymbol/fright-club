extends TextureButton


const MAIN_MENU = preload("res://main_menu/main_menu.tscn")

@onready var node: SlideInMenu = $"../../../.."


func _on_button_up() -> void:
	var main_menu = MAIN_MENU.instantiate()
	main_menu.autoslide = false
	$/root/Main.add_child(main_menu)
	node.slide_reversed()
	await node.finished_reverse
	node.queue_free()
