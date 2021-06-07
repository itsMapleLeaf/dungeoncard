extends Node

const field_size := Vector2(5, 5)
const platform_separation := Vector2(190, 130)
	
var entity_manager := EntityManager.new()

var player: EntityManager.Entity

onready var platform_grid := $PlatformGridContainer/PlatformGrid as GridContainer
onready var world := $World as Node2D
onready var hand := $Hand as HBoxContainer

onready var deck := []

func _ready() -> void:
	randomize()
	
	platform_grid.add_constant_override("hseparation", platform_separation.x)
	platform_grid.add_constant_override("vseparation", platform_separation.y)
	
	for i in Helpers.points_within_rect(Rect2(Vector2(), field_size)):
		create_platform()
	
	var enemy_spawn_positions := Helpers.points_within_rect(Rect2(Vector2(2, 0), field_size - Vector2(2, 0)))
	enemy_spawn_positions.shuffle()
	for i in 3:
		spawn_enemy(enemy_spawn_positions.pop_front())

	spawn_player(Vector2(0, floor(field_size.y / 2)))
	
	build_deck()
	deck.shuffle()
	for i in 3:
		draw_card()

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

func create_platform() -> void:
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
	
func try_attack():
	(player.node as Player).play_attack_animation()
	for dir in [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]:
		var ent := entity_manager.get_entity_at_position(player.field_pos + dir)
		if ent != null and ent.node is Slime:
			entity_manager.remove(ent)
			break

func build_deck():
	for type in Card.get_card_types():
		var card := preload("res://game/card.tscn").instance() as Card
		card.set_type(type)
		card.connect("clicked", self, "play_card", [card])
		deck.append(card)

func draw_card():
	deck.shuffle()
	var card := deck.pop_front() as Card
	hand.add_child(card)
	card.play_reveal_animation()
	
func play_card(card: Card):
	match card.type:
		Card.CardType.MOVE_LEFT:
			move_player(Vector2.LEFT)
		Card.CardType.MOVE_RIGHT:
			move_player(Vector2.RIGHT)
		Card.CardType.MOVE_UP:
			move_player(Vector2.UP)
		Card.CardType.MOVE_DOWN:
			move_player(Vector2.DOWN)
		Card.CardType.ATTACK:
			try_attack()

	draw_card()
	hand.remove_child(card)
	deck.append(card)


