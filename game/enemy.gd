extends Node2D
class_name Enemy

signal damaged_target

var map_pos := Vector2()
var target_map_pos: Vector2

const speed := 200.0
const max_health := 3.0
var health := max_health

onready var health_bar := $HealthBar
onready var controller := $PhysicsController

func _ready():
	health_bar.rect_pivot_offset = health_bar.rect_size / 2
	
	var movement_timer := Timer.new()
	movement_timer.wait_time = 2
	movement_timer.autostart = true
	movement_timer.connect("timeout", self, "move_towards_target")
	add_child(movement_timer)
	
func _process(delta: float) -> void:
	global_position = lerp(global_position, map_pos * 32, delta * 10)

func damage() -> bool:
	health -= 1
	health_bar.rect_scale.x = health / max_health
	return health <= 0
		
func set_target(new_target: Vector2) -> void:
	target_map_pos = new_target
	
func clear_target() -> void:
	# i don't know how to set target_map_pos to null so todo
	pass

func move_towards_target() -> void:
	if !target_map_pos: return
	
	map_pos += to_nearest_cardinal(map_pos.direction_to(target_map_pos))

func to_nearest_cardinal(vec: Vector2) -> Vector2:
	if abs(vec.x) > abs(vec.y):
		return Vector2(sign(vec.x), 0)
	return Vector2(0, sign(vec.y))
