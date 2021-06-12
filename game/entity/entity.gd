extends Node2D
class_name Entity

var field_pos := Vector2.ZERO

func update_screen_position(screen_pos: Vector2, delta: float) -> void:
	global_position = lerp(global_position, screen_pos, min(delta * 15, 1))
