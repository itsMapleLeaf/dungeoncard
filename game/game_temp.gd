extends Node

const field_size := Vector2(5, 5)
const platform_spacing := Vector2(8, 4)

onready var viewport_center := get_viewport().size / 2

func _ready() -> void:
	for x in field_size.x:
		for y in field_size.y:
			var platform: Sprite = preload("res://game/platform.tscn").instance()
			var platform_size := platform.get_rect().size
			
			var top_left = viewport_center + platform_size / 2 - field_size / 2 * (platform_size + platform_spacing) + platform_spacing
			var local_pos = Vector2(x, y) * (platform_size + platform_spacing)
			
			platform.global_position = top_left + local_pos
			
			add_child(platform)
