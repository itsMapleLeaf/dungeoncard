extends Node
class_name PhysicsController

var velocity := Vector2(0, 0)
const speed := 300.0
const velocity_damping := 5.0

onready var body: KinematicBody2D = get_parent()

func _physics_process(delta: float) -> void:
	velocity = lerp(velocity, Vector2(0, 0), delta * velocity_damping)
	
	if not velocity.is_equal_approx(Vector2(0, 0)):
		velocity = body.move_and_slide(velocity)
