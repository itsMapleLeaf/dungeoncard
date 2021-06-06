extends Node2D
class_name PlayerOld

const speed := 300.0

var max_health := 5.0
var health := max_health

var ghosting := false # if the player can take damage
const ghosting_time := 1.5

onready var world: GameWorld = $"./GameWorld"
onready var sprite: AnimatedSprite = $IdleAnimation
onready var health_bar := $IdleAnimation/HealthBar

func _ready() -> void:
	world.register_entity_at_random_pos(self)

func _process(delta: float) -> void:
	var map_pos = world.get_map_pos(self)
	global_position = lerp(global_position, map_pos * 32, delta * 10)
	sprite.modulate.a = 0.5 if ghosting else 1.0

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		match event.scancode:
			KEY_LEFT: world.try_move(self, Vector2.LEFT)
			KEY_RIGHT: world.try_move(self, Vector2.RIGHT)
			KEY_UP: world.try_move(self, Vector2.UP)
			KEY_DOWN: world.try_move(self, Vector2.DOWN)

#
#func _input(event: InputEvent) -> void:
#	# debug movement
#	if event is InputEventKey and event.is_pressed():
#		match event.scancode:
#			KEY_LEFT: map_pos += Vector2.LEFT
#			KEY_RIGHT: map_pos += Vector2.RIGHT
#			KEY_UP: map_pos += Vector2.UP
#			KEY_DOWN: map_pos += Vector2.DOWN

#func move(dir: Vector2) -> void:
#	var prev_pos = global_position
#
#	move_and_collide(dir * 32)
#	global_position = floor_vec(global_position / 32) * 32
#
#	sprite.global_position = prev_pos

#func try_attack() -> void:
#	for dir in [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]:
#		var point: Vector2 = (map_pos + dir) * 32
#		var results := get_world_2d().direct_space_state.intersect_point(point)
#		for result in results:
#			var node = result.collider as Node2D
#			if node and node.is_in_group("enemies"):
#				var is_dead = result.collider.damage()
#				if is_dead: result.collider.queue_free()
#				return
#
#func damage() -> void:
#	if ghosting: return
#
#	health = max(health - 1, 0)
#	health_bar.rect_scale.x = health / max_health
#
#	ghosting = true
#	yield(get_tree().create_timer(ghosting_time), "timeout")
#	ghosting = false
#
#	# todo: end game, erase self from computer, set computer on fire, end planet
#
#func floor_vec(vec: Vector2) -> Vector2:
#	return Vector2(floor(vec.x), floor(vec.y))
