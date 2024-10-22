extends Node


func _ready() -> void:
	$"../CountUpLabel".count_up_from_to(0, $/root/Main/LevelManager.score)
