extends AnimatedSprite2D


var direction = 0
var walking = false


func update_direction_from_rad(angle: float):
	angle = wrapf(angle, 0.0, TAU)
	var value = int((angle / TAU) * 4)
	update_direction(value)


func update_direction(value: int):
	direction = value


func update_walking(value: bool):
	walking = value


func flush_to_animation():
	if direction == 0:
		flip_h = true
		if walking:
			play("move_lr")
		else:
			play("idle_lr")
	elif direction == 1:
		flip_h = false
		if walking:
			play("move_d")
		else:
			play("idle_d")
	elif direction == 2:
		flip_h = false
		if walking:
			play("move_lr")
		else:
			play("idle_lr")
	elif direction == 3:
		flip_h = false
		if walking:
			play("move_u")
		else:
			play("idle_u")
