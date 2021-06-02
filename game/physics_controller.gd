extends Node
class_name PhysicsController

var velocity := Vector2(0, 0)
const speed := 300.0
const velocity_damping := 5.0

func update(delta: float, body: KinematicBody2D) -> void:
	velocity = lerp(velocity, Vector2(0, 0), delta * velocity_damping)
	
	if not velocity.is_equal_approx(Vector2(0, 0)):
		velocity = body.move_and_slide(velocity)
