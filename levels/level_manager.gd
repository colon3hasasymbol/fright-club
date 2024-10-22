extends CanvasLayer
class_name LevelManager


const LEVELS = [
	preload("res://ring/ring.tscn"),
	preload("res://ring/ring_2.tscn"),
	preload("res://ring/ring_3.tscn"),
	preload("res://ring/ring_4.tscn"),
	preload("res://ring/ring_5.tscn"),
]

const MAIN_MENU = preload("res://main_menu/main_menu.tscn")
const WIN_SCREEN = preload("res://win_screen/win_screen.tscn")
const LOSS_SCREEN = preload("res://loss_screen/loss_screen.tscn")
const BETWEEN_LEVELS_MENU = preload("res://levels/between_levels_menu.tscn")
const PAUSE_MENU = preload("res://pause_menu/pause_menu.tscn")
const BRAWL_MENU = preload("res://brawl_menu/brawl_menu.tscn")

const BRAWL_LEVEL = preload("res://brawl/brawl_ring.tscn")

@onready var main: Node = $/root/Main
@onready var settings_manager: SettingsManager = main.get_node("SettingsManager")

@export var player_inventory: Inventory

var current_level = 0
var score = 0
var money = 0
var player_health = 0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if main.has_node("BrawlRing"):
			pause_brawl()
		if get_tree().get_node_count_in_group("levels") != 0:
			pause_run()
	elif event.is_action("oink_mode_win") && !main.has_node("MainMenu") && !main.has_node("WinScreen") && settings_manager.is_oink_mode_enabled():
		current_level = LEVELS.size()
		next_level()


func _ready() -> void:
	get_tree().node_removed.connect(func(node: Node): if node.is_in_group("enemies") && !main.has_node("BrawlRing") && !main.has_node("PauseMenu") && !main.has_node("LossScreen") && !PauseSystem.everything_paused: if get_tree().get_node_count_in_group("enemies") == 1: get_tree().create_timer(0.2).timeout.connect(next_level))


func start_run():
	score = 0
	current_level = 0
	next_level()


func pause_run():
	if !main.has_node("PauseMenu"):
		print("run paused!")
		PauseSystem.everything_paused = true
		var pause_menu = PAUSE_MENU.instantiate()
		main.add_child(pause_menu)
		var level_slide_in_menu = get_tree().get_first_node_in_group("levels").get_node("SlideInMenu")
		var sig1 = pause_menu.get_node("CenterContainer/VBoxContainer/MarginContainer/MainMenuButton").button_up
		var sig2 = pause_menu.get_node("CenterContainer/VBoxContainer/MarginContainerSettings/TextureButton").button_up
		sig1.connect(func(): var main_menu = MAIN_MENU.instantiate(); main_menu.autoslide = false; $/root/Main.add_child(main_menu); level_slide_in_menu.slide_reversed(); pause_menu.slide_reversed(); await pause_menu.finished_reverse; pause_menu.queue_free(); level_slide_in_menu.get_parent().free(); current_level = 0; PauseSystem.everything_paused = false)
		sig2.connect(func(): pause_menu.slide_reversed(); await pause_menu.finished_reverse; pause_menu.queue_free(); PauseSystem.everything_paused = false)


func next_level():
	var between_levels_menu
	
	if current_level == 0:
		var level = LEVELS[current_level].instantiate()
		main.add_child(level)
		if main.has_node("MainMenu"):
			var slide = level.get_node("SlideInMenu")
			slide.slide()
			await slide.finished
			main.get_node("MainMenu").queue_free()
	elif get_tree().get_node_count_in_group("levels") != 0:
		var level = get_tree().get_first_node_in_group("levels")
		print("level: ", level)
		var level_slide_in_menu = level.get_node("SlideInMenu")
		print("level slide in menu: ", level_slide_in_menu)
		var player = level_slide_in_menu.get_node("YSortNode/Player")
		print("player: ", player)
		var hit_relay = player.get_node("HitRelay")
		print("hit relay: ", hit_relay)
		var player_health = hit_relay.health
		print("player health: ", player_health)
		var level_existance_time = level.get_node("SlideInMenu/BaseRing").existance_time
		print("level existance time: ", level_existance_time)
		print("current level: ", current_level)
		var level_score = int(current_level * player_health) / (level_existance_time / current_level)
		score += level_score
		if current_level != LEVELS.size():
			between_levels_menu = BETWEEN_LEVELS_MENU.instantiate()
			add_child(between_levels_menu)
			#for node in get_tree().get_nodes_in_group("levels"): node.get_node("SlideInMenu").layer -= 1
			between_levels_menu.slide()
			await between_levels_menu.finished
			between_levels_menu.get_node("CenterContainer/VBoxContainer/MarginContainer/MarginContainer/Text").count_up_from_to(0, level_score)#level.existance_time * ((level.get_node("SlideInMenu/Player/HitRelay").health % 100) * 1000))
			for node in get_tree().get_nodes_in_group("levels"): node.queue_free()
			await between_levels_menu.get_node("CenterContainer/VBoxContainer/CenterContainer2/NextLevelButton").button_up
			main.add_child(LEVELS[current_level].instantiate())
			between_levels_menu.slide_reversed()
			await between_levels_menu.finished_reverse
			between_levels_menu.queue_free()
	
	#get_tree().create_timer(0.2).timeout.connect(func(): if get_tree().get_node_count_in_group("levels") != 0: get_tree().get_first_node_in_group("levels").queue_free(); main.add_child(LEVELS[current_level].instantiate()))
	if current_level == LEVELS.size():
		#for node in get_tree().get_nodes_in_group("levels"): node.get_node("SlideInMenu").layer -= 1
		settings_manager.test_and_add_score(score)
		settings_manager.save_settings()
		var win_screen = WIN_SCREEN.instantiate()
		main.add_child(win_screen)
		win_screen.slide()
		await win_screen.finished
		for node in get_tree().get_nodes_in_group("levels"): node.queue_free()
	
	settings_manager.save_settings()
	current_level += 1
	
	if get_tree().get_node_count_in_group("levels") != 0:
		print("kjrgfhsk")
		get_tree().get_first_node_in_group("levels").get_node("SlideInMenu/BaseRing/MarginContainer/CenterContainer/Label").count_up_from_to(0, score)
	
	player_health = 100


func start_brawl():
	player_health = 100
	print("brawl starting!")
	var level = BRAWL_LEVEL.instantiate()
	main.add_child(level)
	if main.has_node("MainMenu") || main.has_node("BrawlMenu"):
		var level_slide_in_menu = level.get_node("SlideInMenu")
		level_slide_in_menu.slide()
		await level_slide_in_menu.finished
	if main.has_node("MainMenu"):
		print("main menu exists!")
		main.get_node("MainMenu").queue_free()
	if main.has_node("BrawlMenu"):
		print("brawl menu exists!")
		main.get_node("BrawlMenu").queue_free()


func end_brawl():
	print("brawl ending!")
	settings_manager.test_and_add_brawl_score(money)
	settings_manager.test_and_add_brawl_time(main.get_node("BrawlRing/SlideInMenu/BaseRing").existance_time)
	settings_manager.save_settings()
	var level_slide_in_menu = main.get_node("BrawlRing").get_node("SlideInMenu")
	level_slide_in_menu.get_parent().queue_free()


func pause_brawl():
	if !main.has_node("PauseMenu"):
		print("brawl paused!")
		PauseSystem.everything_paused = true
		var pause_menu = PAUSE_MENU.instantiate()
		main.add_child(pause_menu)
		var level_slide_in_menu = main.get_node("BrawlRing").get_node("SlideInMenu")
		var sig1 = pause_menu.get_node("CenterContainer/VBoxContainer/MarginContainer/MainMenuButton").button_up
		var sig2 = pause_menu.get_node("CenterContainer/VBoxContainer/MarginContainerSettings/TextureButton").button_up
		sig1.connect(func(): var main_menu = MAIN_MENU.instantiate(); main_menu.autoslide = false; main.add_child(main_menu); var brawl_menu = BRAWL_MENU.instantiate(); brawl_menu.autoslide = false; settings_manager.test_and_add_brawl_score(money); settings_manager.test_and_add_brawl_time(main.get_node("BrawlRing").existance_time); settings_manager.save_settings(); main.add_child(brawl_menu); level_slide_in_menu.slide_reversed(); pause_menu.slide_reversed(); await pause_menu.finished_reverse; pause_menu.queue_free(); end_brawl(); current_level = 0; money = 0; player_health = 100; PauseSystem.everything_paused = false)
		sig2.connect(func(): pause_menu.slide_reversed(); await pause_menu.finished_reverse; pause_menu.queue_free(); PauseSystem.everything_paused = false)


func lose_game():
	if !main.has_node("LossScreen"):
		if main.has_node("BrawlRing"):
			score = money
			settings_manager.test_and_add_brawl_score(money)
			settings_manager.test_and_add_brawl_time(main.get_node("BrawlRing/SlideInMenu/BaseRing").existance_time)
			settings_manager.save_settings()
		if get_tree().get_node_count_in_group("levels") != 0:
			settings_manager.test_and_add_score(score)
			settings_manager.save_settings()
		var loss_screen = LOSS_SCREEN.instantiate()
		main.add_child(loss_screen)
		loss_screen.get_node("ButtonsContainer/HBoxContainer/NewRunButton").was_lost_game_brawl = main.has_node("BrawlRing")
		loss_screen.slide()
		await loss_screen.finished
		if main.has_node("BrawlRing"):
			money = 0
			end_brawl()
		if get_tree().get_node_count_in_group("levels") != 0:
			score = 0
			get_tree().get_first_node_in_group("levels").free()


func add_money(amount: int):
	print("jiberdydoop")
	if main.has_node("BrawlRing"):
		print("glonklers")
		main.get_node("BrawlRing/SlideInMenu/BaseRing/MarginContainer/CenterContainer/Label").count_up_from_to(money, money + amount)
	money += amount


func set_player_health(value: int):
	if main.has_node("BrawlRing"):
		main.get_node("BrawlRing/SlideInMenu/BaseRing/MarginContainer3/MarginContainer/TextureProgressBar").slide_from_to(player_health, value)
	if get_tree().get_node_count_in_group("levels") != 0:
		get_tree().get_first_node_in_group("levels").get_node("SlideInMenu/BaseRing/MarginContainer3/MarginContainer/TextureProgressBar").slide_from_to(player_health, value)
	player_health = value
	print("new player health: ", player_health)


func get_player_health() -> int:
	return player_health
