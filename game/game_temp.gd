extends Node

const field_size := Vector2(5, 5)
const platform_separation := Vector2(190, 130)
	
var entity_manager := EntityManager.new()

var player: EntityManager.Entity

onready var platform_grid := $PlatformGridContainer/PlatformGrid as GridContainer
onready var world := $World as Node2D
onready var hand := $Hand as HBoxContainer

func _ready() -> void:
	randomize()
	
	platform_grid.add_constant_override("hseparation", platform_separation.x)
	platform_grid.add_constant_override("vseparation", platform_separation.y)
	
	var field_positions := points_within_area(field_size)
	
	for pos in field_positions:
		create_platform(pos)
	
	field_positions.shuffle()
	
	for i in 3: spawn_enemy(field_positions.pop_front())
	spawn_player(field_positions.pop_front())
	
	var card_types := Card.get_card_types()
	card_types.shuffle()
	for type in card_types:
		var card := preload("res://game/card.tscn").instance() as Card
		hand.add_child(card)
		card.set_type(type)
	
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
		KEY_SPACE: (player.node as Player).play_attack_animation()

func create_platform(field_pos: Vector2) -> void:
	var platform := preload("res://game/platform.tscn").instance() as Control
	platform_grid.add_child(platform)

func spawn_enemy(field_pos: Vector2) -> void:
	var slime := preload("res://game/slime.tscn").instance() as Slime
	world.add_child(slime)
	entity_manager.add_at(field_pos, slime)

func spawn_player(field_pos: Vector2) -> void:
	var player_node := preload("res://game/player.tscn").instance() as Player
	world.add_child(player_node)
	player = entity_manager.add_at(field_pos, player_node)
	player_node.animate_screen_position(get_screen_pos(field_pos), 1)
	
func get_screen_pos(field_pos: Vector2) -> Vector2:
	return platform_grid.rect_position + field_pos * platform_separation

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
