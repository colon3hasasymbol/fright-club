extends RigidBody2D
class_name HitDodger


const DODGE_SPEED = 250.0


func dodge_hit(direction: Vector2):
	linear_velocity = direction.normalized().rotated(PI / 2) * DODGE_SPEED
