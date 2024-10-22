class_name PauseSystem


class PauseSystemSignalContainer:
	signal player_paused_changed(value: bool)
	signal input_paused_changed(value: bool)
	signal enemies_paused_changed(value: bool)
	signal everything_paused_changed(value: bool)

static var signal_container = PauseSystemSignalContainer.new()

static var player_paused = false : set = set_player_paused
static var input_paused = false : set = set_input_paused
static var enemies_paused = false : set = set_enemies_paused
static var everything_paused = true : set = set_everything_paused

static func set_player_paused(value: bool): signal_container.player_paused_changed.emit(value); player_paused = value
static func set_input_paused(value: bool): signal_container.input_paused_changed.emit(value); input_paused = value
static func set_enemies_paused(value: bool): signal_container.enemies_paused_changed.emit(value); enemies_paused = value
static func set_everything_paused(value: bool): signal_container.player_paused_changed.emit(value); signal_container.input_paused_changed.emit(value); signal_container.enemies_paused_changed.emit(value); signal_container.everything_paused_changed.emit(value); everything_paused = value


static func reset():
	player_paused = false
	input_paused = false
	enemies_paused = false
	everything_paused = true


static func unpause():
	player_paused = false
	input_paused = false
	enemies_paused = false
	everything_paused = false


static func is_player_paused() -> bool:
	return player_paused || everything_paused


static func is_input_paused() -> bool:
	return input_paused || everything_paused


static func is_enemies_paused() -> bool:
	return enemies_paused || everything_paused
