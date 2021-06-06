extends Node

const field_size := Vector2(7, 5)
const platform_spacing := Vector2(8, 4)
	
var entity_manager := EntityManager.new()

var player: EntityManager.Entity

onready var viewport_center := get_viewport().size / 2

onready var platform_base := preload("res://game/platform.tscn").instance() as Sprite
onready var platform_size := platform_base.get_rect().size

onready var field_screen_top_left := \
	viewport_center + platform_size / 2 - field_size / 2 * \
	(platform_size + platform_spacing) + platform_spacing
	
func _ready() -> void:
	randomize()
	
	create_platforms()
	
	var spawn_positions := points_within_area(field_size)
	spawn_positions.shuffle()
	
	for i in 3: spawn_enemy(spawn_positions.pop_front())
	spawn_player(spawn_positions.pop_front())
	
func _process(delta: float) -> void:
	for i in entity_manager.entities:
		var entity := i as EntityManager.Entity
		var node := entity.node
		if node is Player:
			node.animate_screen_position(get_screen_pos(entity.field_pos), delta)
		if node is Slime:
			node.global_position = get_screen_pos(entity.field_pos)

func _input(event: InputEvent) -> void:
	if event is InputEventKey: if event.is_pressed(): match event.scancode:
		KEY_UP: move_player(Vector2.UP)
		KEY_DOWN: move_player(Vector2.DOWN)
		KEY_LEFT: move_player(Vector2.LEFT)
		KEY_RIGHT: move_player(Vector2.RIGHT)

func create_platforms() -> void:
	for point in points_within_area(field_size):
		var platform := platform_base.duplicate()
		platform.global_position = get_screen_pos(point)
		add_child(platform)

func spawn_enemy(field_pos: Vector2) -> void:
	var slime := preload("res://game/slime.tscn").instance() as Slime
	add_child(slime)
	entity_manager.add_at(field_pos, slime)

func spawn_player(field_pos: Vector2) -> void:
	var player_node := preload("res://game/player.tscn").instance() as Player
	add_child(player_node)
	player = entity_manager.add_at(field_pos, player_node)
	player_node.animate_screen_position(get_screen_pos(field_pos), 1)

func random_field_pos() -> Vector2:
	return Vector2(randi() % int(field_size.x), randi() % int(field_size.y))

func get_screen_pos(field_pos: Vector2) -> Vector2:
	return field_screen_top_left + field_pos * (platform_size + platform_spacing)

func move_player(delta: Vector2) -> void:
	var new_pos := (player.field_pos + delta)
	if entity_manager.is_occupied(new_pos): return
	
	player.field_pos = Vector2(
		clamp(new_pos.x, 0, field_size.x - 1),
		clamp(new_pos.y, 0, field_size.y - 1)
	)

func points_within_area(size: Vector2) -> Array:
	var points := []
	
	for x in size.x: for y in size.y:
		points.append(Vector2(x, y))
	
	return points
