extends Node
class_name HoverAnimation

export var speed: float = 3
export var extents: float = 6
export var time_offset: float = 0

var time := 0.0

onready var parent := get_parent() as Node2D
onready var offset_y: float = parent.position.y

func _process(delta: float):
	time += delta
	parent.position.y = offset_y + sin((time + time_offset) * speed) * extents

