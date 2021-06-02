extends Node2D

var max_health := 5.0
var health := max_health

onready var health_bar := $HealthBar as ColorRect

func move(direction: Vector2, spaces: int) -> void:
	var new_position = global_position + direction.normalized() * 16 * spaces
	var results := get_world_2d().direct_space_state.intersect_point(new_position)
	
	if results.empty():
		global_position = new_position
		return

	for result in results:
		var node: Node2D = result.collider
		if node.is_in_group("enemy"):
			damage()

func damage() -> void:
	health -= 1
	health_bar.rect_scale.x = health / max_health
