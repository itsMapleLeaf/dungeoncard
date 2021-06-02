extends Node2D
class_name Enemy

var health = 1

func damage():
	health -= 1
	if health <= 0:
		queue_free()
