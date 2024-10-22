extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent
@onready var hit_dealer: HitDealer = $HitDealer
@onready var collision_shape: CollisionShape2D = $HitDealer/CollisionShape
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var timer: Timer = $HitDealer/CollisionShape/Timer
@onready var hit_relay: Node = $HitRelay

@export var damage = 10
@export var time_before_punch = 1.0
@export var SPEED = 2000
@export var health = 50

var _is_first_frame = true


func _ready() -> void:
	hit_relay.health = health


func _physics_process(delta: float) -> void:
	hit_dealer.damage = damage
	timer.wait_time = time_before_punch
	#collision_shape.disabled = true
	
	if _is_first_frame:
		_is_first_frame = false
		return
	if !PauseSystem.is_enemies_paused():
		navigation_agent.target_position = get_tree().get_first_node_in_group("players").global_position
		if !navigation_agent.is_navigation_finished():
			var movement = global_position.direction_to(navigation_agent.get_next_path_position()) * SPEED * delta
			sprite.update_direction_from_rad(Vector2().angle_to_point(movement) + PI / 4)
			sprite.update_walking(true)
			sprite.flush_to_animation()
			#_random_velocity = _random_velocity.move_toward(Vector2(), delta * (_random_velocity.length() / 2))
			movement = movement.rotated(randf_range(-(PI / 4), PI / 4))
			navigation_agent.velocity = movement
		else:
			navigation_agent.velocity = Vector2()
			sprite.update_walking(false)
			sprite.flush_to_animation()
	else:
		navigation_agent.velocity = Vector2()


func _on_navigation_agent_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
