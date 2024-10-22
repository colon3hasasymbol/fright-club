extends Node


func _ready() -> void:
	$/root/Main/MusicPlayer.fade_to_menu()


func _exit_tree() -> void:
	if get_tree().get_node_count_in_group("levels") != 0 || $/root/Main.has_node("BrawlRing"):
		$/root/Main/MusicPlayer.fade_to_fighting()
