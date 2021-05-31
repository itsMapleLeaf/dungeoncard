extends Node2D

func move(direction: Vector2) -> void:
	position += direction.normalized() * 16
