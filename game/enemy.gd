extends Node2D
class_name Enemy

const max_health := 3.0
var health := max_health
var target: Node2D

onready var health_bar := $HealthBar as ColorRect

func _ready():
	health_bar.rect_pivot_offset = health_bar.rect_size / 2
	
	var movement_timer := Timer.new()
	movement_timer.wait_time = 2
	movement_timer.autostart = true
	movement_timer.connect("timeout", self, "move_towards_target")
	add_child(movement_timer)

func damage() -> void:
	health -= 1
	health_bar.rect_scale.x = health / max_health
	if health <= 0:
		queue_free()
		
func set_target(new_target: Node2D) -> void:
	target = new_target

func move_towards_target() -> void:
	if target:
		var direction = to_nearest_cardinal(global_position.direction_to(target.global_position))
		global_position += direction * 16

func to_nearest_cardinal(vec: Vector2) -> Vector2:
	if abs(vec.x) > abs(vec.y):
		vec.x = 1 * sign(vec.x)
		vec.y = 0
	else:
		vec.x = 0
		vec.y = 1 * sign(vec.y)
	return vec
