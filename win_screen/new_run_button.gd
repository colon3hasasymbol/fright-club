extends TextureButton


@export var was_lost_game_brawl = false


func _on_button_up() -> void:
	#get_tree().create_timer(0.2).timeout.connect(func(): $"../../..".queue_free(); $/root/Main.add_child(RING.instantiate()))
	if was_lost_game_brawl:
		$/root/Main/LevelManager.start_brawl()
	else:
		$/root/Main/LevelManager.start_run()
	var node = $"../../.."
	node.slide_reversed()
	await node.finished_reverse
	node.queue_free()
