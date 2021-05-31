extends Node2D


func _ready():
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and !event.is_echo():
		match event.scancode:
			KEY_RIGHT:
				global_position.x += 16
			KEY_LEFT:
				global_position.x -= 16
