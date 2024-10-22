extends Node


@onready var fighting_music_animation_player: AnimationPlayer = $FightingMusic/AnimationPlayer
@onready var menu_music_animation_player: AnimationPlayer = $MenuMusic/AnimationPlayer


var is_music_fighting = false


func fade_to_fighting():
	if !is_music_fighting:
		menu_music_animation_player.play("fade_out")
		fighting_music_animation_player.play("fade_in")
		is_music_fighting = true


func fade_to_menu():
	if is_music_fighting:
		fighting_music_animation_player.play("fade_out")
		menu_music_animation_player.play("fade_in")
		is_music_fighting = false
