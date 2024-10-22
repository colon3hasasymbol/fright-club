extends Node
class_name SettingsManager


const DEFAULT_SETTINGS = {
	"oink_mode_enabled": false,
	"high_score": 0,
	"high_brawl_score": 0,
	"high_brawl_time": 0,
	"volume": [1.0, 1.0, 1.0],
	"has_player_played_before": false,
}

var config_file: ConfigFile = ConfigFile.new()

var was_last_score_high_score = false

func _ready() -> void:
	if !FileAccess.file_exists("user://settings.cfg"):
		default_settings()
	config_file.load("user://settings.cfg")
	for bus in range(0, 2):
		AudioServer.set_bus_volume_db(bus, linear_to_db(get_volume(bus)))
		AudioServer.set_bus_mute(bus, get_volume(bus) == 0.0)


func default_settings():
	var file = ConfigFile.new()
	
	for setting_key in DEFAULT_SETTINGS.keys():
		file.set_value("main", setting_key, DEFAULT_SETTINGS[setting_key])
	
	file.save("user://settings.cfg")


func save_settings():
	config_file.save("user://settings.cfg")


func toggle_oink_mode():
	config_file.set_value("main", "oink_mode_enabled", !config_file.get_value("main", "oink_mode_enabled"))


func is_oink_mode_enabled() -> bool:
	return config_file.get_value("main", "oink_mode_enabled")


func test_and_add_score(score: int) -> bool:
	if score > get_high_score():
		config_file.set_value("main", "high_score", score)
		was_last_score_high_score = true
		return true
	was_last_score_high_score = false
	return false


func get_high_score() -> int:
	return config_file.get_value("main", "high_score")


func test_and_add_brawl_score(brawl_score: int) -> bool:
	if brawl_score > get_high_brawl_score():
		config_file.set_value("main", "high_brawl_score", brawl_score)
		return true
	return false


func get_high_brawl_score() -> int:
	return config_file.get_value("main", "high_brawl_score")


func test_and_add_brawl_time(brawl_time: int) -> bool:
	if brawl_time > get_high_brawl_time():
		config_file.set_value("main", "high_brawl_time", brawl_time)
		return true
	return false


func get_high_brawl_time() -> int:
	return config_file.get_value("main", "high_brawl_time")


func set_volume(bus: int, value: float):
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	AudioServer.set_bus_mute(bus, value == 0.0)
	var array = config_file.get_value("main", "volume")
	array[bus] = value
	config_file.set_value("main", "volume", array)


func get_volume(bus: int) -> float:
	return config_file.get_value("main", "volume")[bus]


func set_player_played():
	config_file.set_value("main", "has_player_played_before", true)
