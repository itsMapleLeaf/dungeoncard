extends Node

const field_size := Vector2(7, 5)
const platform_spacing := Vector2(8, 4)

var player: Entity

onready var viewport_center := get_viewport().size / 2

onready var platform_base := preload("res://game/platform.tscn").instance() as Sprite
onready var platform_size := platform_base.get_rect().size

onready var field_screen_top_left := \
	viewport_center + platform_size / 2 - field_size / 2 * \
	(platform_size + platform_spacing) + platform_spacing
	
var entities := []

func _ready() -> void:
	randomize()
	
	create_platforms()
	
	var spawn_positions := points_within_area(field_size)
	spawn_positions.shuffle()
	
	spawn_enemies(spawn_positions)
	spawn_player(spawn_positions)
	
func _process(delta: float) -> void:
	for i in entities:
		var entity := i as Entity
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

func spawn_enemies(spawn_positions: Array) -> void:
	for i in 3:
		var slime := preload("res://game/slime.tscn").instance() as Slime
		add_child(slime)
		
		entities.append(Entity.new(spawn_positions.pop_front(), slime))

func spawn_player(spawn_positions: Array) -> void:
	player = Entity.new(spawn_positions.pop_front(), preload("res://game/player.tscn").instance())
	add_child(player.node)
	entities.append(player)
	player.node.animate_screen_position(get_screen_pos(player.field_pos), 1)

func random_field_pos() -> Vector2:
	return Vector2(randi() % int(field_size.x), randi() % int(field_size.y))

func get_screen_pos(field_pos: Vector2) -> Vector2:
	return field_screen_top_left + field_pos * (platform_size + platform_spacing)

func move_player(delta: Vector2) -> void:
	var new_pos := (player.field_pos + delta)
	if is_occupied(new_pos): return
	
	player.field_pos = Vector2(
		clamp(new_pos.x, 0, field_size.x - 1),
		clamp(new_pos.y, 0, field_size.y - 1)
	)

func points_within_area(size: Vector2) -> Array:
	var points := []
	
	for x in size.x: for y in size.y:
		points.append(Vector2(x, y))
	
	return points
	
func get_entity_at_position(field_pos: Vector2) -> Entity:
	for e in entities:
		if field_pos.is_equal_approx(e.field_pos):
			return e
			
	return null
	
func is_occupied(field_pos: Vector2) -> bool:
	return get_entity_at_position(field_pos) != null

class Entity:
	var field_pos: Vector2
	var node: Node2D
	
	func _init(field_pos: Vector2, node: Node2D) -> void:
		self.field_pos = field_pos
		self.node = node
