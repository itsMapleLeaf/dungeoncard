extends Node

const field_size := Vector2(7, 5)
const platform_spacing := Vector2(8, 4)

var player := preload("res://game/player.tscn").instance() as Player
var player_pos := Vector2(1, 1)
const player_animation_speed := 18

onready var viewport_center := get_viewport().size / 2

onready var platform_base := preload("res://game/platform.tscn").instance() as Sprite
onready var platform_size := platform_base.get_rect().size

onready var field_screen_top_left := \
	viewport_center + platform_size / 2 - field_size / 2 * \
	(platform_size + platform_spacing) + platform_spacing

func _ready() -> void:
	for x in field_size.x:
		for y in field_size.y:
			var platform := platform_base.duplicate()
			platform.global_position = get_screen_pos(Vector2(x, y))
			add_child(platform)
	
	add_child(player)
	player.animate_screen_position(get_screen_pos(player_pos), 1)
	
func _process(delta: float) -> void:
	player.animate_screen_position(get_screen_pos(player_pos), delta)

func _input(event: InputEvent) -> void:
	if event is InputEventKey: if event.is_pressed(): match event.scancode:
		KEY_UP: move_player(Vector2.UP)
		KEY_DOWN: move_player(Vector2.DOWN)
		KEY_LEFT: move_player(Vector2.LEFT)
		KEY_RIGHT: move_player(Vector2.RIGHT)

func get_screen_pos(field_pos: Vector2) -> Vector2:
	return field_screen_top_left + field_pos * (platform_size + platform_spacing)

func move_player(delta: Vector2) -> void:
	var new_pos := (player_pos + delta)
	player_pos = Vector2(
		clamp(new_pos.x, 0, field_size.x - 1),
		clamp(new_pos.y, 0, field_size.y - 1)
	)
