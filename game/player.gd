extends Node2D

func move(direction: Vector2, spaces: int) -> void:
	position += direction.normalized() * 16 * spaces
