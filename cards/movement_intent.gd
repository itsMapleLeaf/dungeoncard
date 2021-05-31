extends Node
class_name MovementIntent

enum MovementIntentDirection {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

export(MovementIntentDirection) var direction

func get_direction_vector() -> Vector2:
	match direction:
		MovementIntentDirection.UP: return Vector2.UP
		MovementIntentDirection.DOWN: return Vector2.DOWN
		MovementIntentDirection.LEFT: return Vector2.LEFT
		MovementIntentDirection.RIGHT, _: return Vector2.RIGHT
