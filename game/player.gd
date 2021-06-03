extends Node2D
class_name Player

var map_pos := Vector2()

const speed := 300.0

var max_health := 5.0
var health := max_health

var ghosting := false # if the player can take damage
const ghosting_time := 1.5

onready var health_bar := $HealthBar
onready var sprite := $IdleAnimation

func _process(delta: float) -> void:
	global_position = lerp(global_position, map_pos * 32, delta * 10)
	sprite.modulate.a = 0.5 if ghosting else 1.0
	
func _input(event):
	# debug movement
	if event is InputEventKey and event.is_pressed():
		match event.scancode:
			KEY_LEFT: map_pos += Vector2.LEFT
			KEY_RIGHT: map_pos += Vector2.RIGHT
			KEY_UP: map_pos += Vector2.UP
			KEY_DOWN: map_pos += Vector2.DOWN

func damage() -> void:
	if ghosting: return
	
	health = max(health - 1, 0)
	health_bar.rect_scale.x = health / max_health
	
	ghosting = true
	yield(get_tree().create_timer(ghosting_time), "timeout")
	ghosting = false

	# todo: end game, erase self from computer, set computer on fire, end planet
