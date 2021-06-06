extends Node
class_name HoverAnimation

export var speed := 3
export var extents := 6
export var time_offset := 0.0

onready var parent := get_parent() as Node2D
onready var offset_y: float = parent.position.y

var time := 0.0

func _process(delta: float):
	time += delta
	parent.position.y = offset_y + sin((time + time_offset) * speed) * extents

