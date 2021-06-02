extends Node2D

var max_health := 5.0
var health := max_health

onready var health_bar := $HealthBar as ColorRect

func move(direction: Vector2, spaces: int) -> void:
	position += direction.normalized() * 16 * spaces

func damage() -> void:
	health -= 1
	health_bar.rect_scale.x = health / max_health
