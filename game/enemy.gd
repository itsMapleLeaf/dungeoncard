extends Node2D
class_name Enemy

const max_health := 3.0
var health := max_health

onready var health_bar := $HealthBar as ColorRect

func _ready():
	health_bar.rect_pivot_offset = health_bar.rect_size / 2

func damage():
	health -= 1
	health_bar.rect_scale.x = health / max_health
	if health <= 0:
		queue_free()
