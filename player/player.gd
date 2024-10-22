extends RigidBody2D


const SPEED = 3000.0
const ATTACK_MINIDASH_SPEED = 250.0
const DASH_SPEED = 500.0

@onready var small_scare_sounds: AudioStreamPlayer = $SmallScareSounds
@onready var small_scare_hit_dealer: HitDealer = $HitDealer
@onready var small_scare_hit_dealer_collision_shape: CollisionShape2D = $HitDealer/CollisionShape
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var da_pig: Sprite2D = $DaPig
@onready var settings_manager: SettingsManager = $/root/Main/SettingsManager
@onready var level_manager: LevelManager = $/root/Main/LevelManager
@onready var animation_player: AnimationPlayer = $SmallScareRecharge/AnimationPlayer
@onready var auto_targeter: AutoTargeter = $AutoTargeter
@onready var dashing_collision_shape: CollisionShape2D = $HitDealer/DashingCollisionShape
@onready var dash_sound: AudioStreamPlayer = $DashSound

var small_scare_active = false
var is_dashing = false
var dash_on_cooldown = false

var dash_velocity = Vector2()


func _ready() -> void:
	PauseSystem.signal_container.input_paused_changed.connect(func(value: bool): if !value: unpause())


func _physics_process(delta: float) -> void:
	var direction
	if !PauseSystem.is_input_paused():
		var t := Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
		direction = t if t else null
	
	if Input.is_action_just_pressed("small_scare") && !PauseSystem.is_input_paused() && !small_scare_active:
		if settings_manager.is_oink_mode_enabled():
			da_pig.visible = true
			get_tree().create_timer(1).timeout.connect(func(): da_pig.visible = false)
		
		animation_player.play("move_up")
		
		if direction:
			dash_velocity += (Vector2().direction_to(direction) * ATTACK_MINIDASH_SPEED) + Vector2(randf_range(-128, 128), randf_range(-128, 128))
		else:
			dash_velocity += (global_position.direction_to(auto_targeter.global_position) * ATTACK_MINIDASH_SPEED) + Vector2(randf_range(-128, 128), randf_range(-128, 128))
	
		if !direction:
			sprite.update_direction_from_rad(small_scare_hit_dealer.rotation + PI / 4)
			sprite.flush_to_animation()
		
		small_scare_hit_dealer_collision_shape.disabled = false
		small_scare_active = true
		physics_material_override.bounce = 0.5
		get_tree().create_timer(0.2).timeout.connect(func(): small_scare_hit_dealer_collision_shape.disabled = true; small_scare_active = false; physics_material_override.bounce = 0.0)
		
		small_scare_sounds.play()
	
	if Input.is_action_just_pressed("dash") && !PauseSystem.is_input_paused() && !is_dashing && !dash_on_cooldown:
		if settings_manager.is_oink_mode_enabled():
			da_pig.visible = true
			get_tree().create_timer(1).timeout.connect(func(): da_pig.visible = false)
		
		dash_sound.play()
		
		var dash_movement_vector = direction * DASH_SPEED if direction else global_position.direction_to(auto_targeter.global_position) * DASH_SPEED
		
		dash_velocity += dash_movement_vector + Vector2(randf_range(-128, 128), randf_range(-128, 128))
		
		if !direction:
			sprite.update_direction_from_rad(small_scare_hit_dealer.rotation + PI / 4)
			sprite.flush_to_animation()
		
		is_dashing = true
		dash_on_cooldown = true
		dashing_collision_shape.disabled = false
		small_scare_hit_dealer.damage = 10
		get_tree().create_timer(0.3).timeout.connect(func(): end_dash(); dash_on_cooldown = false)
	
	if direction:
		if !PauseSystem.is_input_paused():
			sprite.update_walking(true)
			sprite.update_direction_from_rad(Vector2().angle_to_point(direction) + PI / 4)
			sprite.flush_to_animation()
		if is_dashing || small_scare_active:
			linear_velocity = Vector2()
		else:
			linear_velocity = direction * delta * SPEED
		small_scare_hit_dealer.rotation = Vector2().angle_to_point(direction)
	else:
		if !PauseSystem.is_input_paused():
			sprite.update_walking(false)
			sprite.flush_to_animation()
		linear_velocity = Vector2()
		small_scare_hit_dealer.rotation = global_position.angle_to_point(auto_targeter.global_position)
	
	#if is_dashing && get_colliding_bodies().size() != 0: end_dash()
	
	if is_dashing:
		collision_layer &= 1 >> 1
		collision_mask &= 1 >> 1
	else:
		collision_layer |= 1
		collision_mask |= 1
	
	linear_velocity += dash_velocity
	dash_velocity = Vector2(move_toward(linear_velocity.x, 0, delta * SPEED), move_toward(linear_velocity.y, 0, delta * SPEED))


func _on_hit_dealer_hit_landed(hitbox: HitBox, damage: float, hitbox_died: bool) -> void:
	if hitbox_died:
		if $/root/Main.has_node("BrawlRing"):
			level_manager.add_money(10)
		if Engine.time_scale != 0.1:
			Engine.time_scale = 0.1
			get_tree().create_timer(0.03).timeout.connect(func(): Engine.time_scale = 1.0)
	auto_targeter.set_combo_target(hitbox, 5.0)


func end_dash():
	if is_dashing:
		dash_velocity = Vector2()
		is_dashing = false
		dashing_collision_shape.set_deferred("disabled", true)
		small_scare_hit_dealer.damage = 20
		auto_targeter.update_targeting()


func _on_body_entered(body: Node) -> void:
	end_dash()


func unpause():
	sprite.update_direction(3)
	sprite.flush_to_animation()
	auto_targeter.visible = true
	auto_targeter.enabled = true
	auto_targeter.update_targeting()
