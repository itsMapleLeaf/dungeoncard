extends Node2D
class_name Slime

const animation_speed := 4

var time := 0.0

onready var body := $Body as Sprite

func _process(delta: float):
	time += delta
	body.scale.y = lerp(0.8, 1, abs(sin(time * animation_speed)))
