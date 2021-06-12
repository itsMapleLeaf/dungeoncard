extends Node
class_name Level

signal complete

const field_size := Vector2(5, 5)
const field_rect := Rect2(Vector2.ZERO, field_size)

const platform_separation := Vector2(190, 130)

var player: Entity

onready var platform_grid := $PlatformGridContainer/PlatformGrid as GridContainer
onready var field := $EntityField as Node
onready var hand := $Hand as HBoxContainer

onready var deck := []

func _ready() -> void:
	randomize()
	
	platform_grid.columns = field_size.x as int
	platform_grid.add_constant_override("hseparation", platform_separation.x as int)
	platform_grid.add_constant_override("vseparation", platform_separation.y as int)
	
	for i in field_size.x * field_size.y:
		create_platform()
	
	# other starting positions depend on the grid being the correct size/position,
	# so we'll wait until it's sorted that layout stuff out before continuing
	yield(platform_grid, "sort_children")

	# all board positions except the spaces on the left
	# so the player doesn't spawn right next to an enemy
	var enemy_spawn_positions := Helpers.points_within_rect(Rect2(Vector2(2, 0), field_size - Vector2(2, 0)))
	enemy_spawn_positions.shuffle()
	for i in 3:
		spawn_enemy(enemy_spawn_positions.pop_front())

	spawn_player(Vector2(0, floor(field_size.y / 2)))
	
	build_deck()
	deck.shuffle()
	for i in 3:
		hand.add_child(draw_card())

func _process(delta: float) -> void:
	for node in field.get_children():
		if node is Entity:
			node.global_position = lerp(node.global_position, get_screen_pos(node.field_pos), delta * 15)
		if node is Slime:
			node.set_remaining_time_display($SlimeMoveTimer.time_left / $SlimeMoveTimer.wait_time)

func _input(event: InputEvent) -> void:
	if event is InputEventKey: if event.is_pressed(): match event.scancode:
		KEY_UP: move_player(Vector2.UP)
		KEY_DOWN: move_player(Vector2.DOWN)
		KEY_LEFT: move_player(Vector2.LEFT)
		KEY_RIGHT: move_player(Vector2.RIGHT)
		KEY_SPACE: (player.node as Player).play_attack_animation()

func is_free_space(pos: Vector2) -> bool:
	var other = get_entity_at_position(pos)
	return other == null \
		and pos.x >= field_size.x and pos.x < field_size.x \
		and pos.y >= field_size.y and pos.y < field_size.y

func get_entity_at_position(field_pos: Vector2) -> Entity:
	for e in field.get_children():
		if e is Entity and field_pos.is_equal_approx(e.field_pos):
			return e
			
	return null
	
func is_occupied(field_pos: Vector2) -> bool:
	return get_entity_at_position(field_pos) != null

# returns the entity that blocked movement, if any
func try_move_entity(entity: Entity, new_pos: Vector2) -> Entity:
	var other = get_entity_at_position(new_pos)
	if other != null: return other
	
	entity.field_pos = Vector2(
		clamp(new_pos.x, 0, field_size.x - 1),
		clamp(new_pos.y, 0, field_size.y - 1)
	)
	return null

func create_platform() -> void:
	var platform := preload("res://game/platform/platform.tscn").instance() as Control
	platform_grid.add_child(platform)

func spawn_enemy(field_pos: Vector2) -> void:
	var slime := preload("res://game/slime/slime.tscn").instance() as Slime
	field.add_child(slime)
	slime.field_pos = field_pos
	slime.global_position = get_screen_pos(field_pos)

func get_enemy_count() -> int:
	var enemy_count := 0
	for entity in field.get_children():
		if entity is Slime:
			enemy_count += 1
	return enemy_count

func spawn_player(field_pos: Vector2) -> void:
	player = preload("res://game/player/player.tscn").instance() as Player
	field.add_child(player)
	player.field_pos = field_pos
#	player_node.animate_screen_position(get_screen_pos(field_pos), 1)

func move_player(delta: Vector2) -> void:
	try_move_entity(player, player.field_pos + delta)

func try_attack() -> bool:
	player.play_attack_animation()
	for dir in [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]:
		var ent := get_entity_at_position(player.field_pos + dir)
		if ent != null and ent is Slime:
			ent.queue_free()
			return true
			
	return false

func build_deck():
	for card in deck:
		card.queue_free()
	
	deck = []
	
	for type in Card.get_card_types():
		var card := preload("res://game/card/card.tscn").instance() as Card
		card.set_type(type)
		card.connect("clicked", self, "play_card", [card])
		deck.append(card)

func draw_card() -> Card:
	deck.shuffle()
	var card := deck.pop_front() as Card
	card.play_reveal_animation()
	return card
	
func play_card(card: Card):
	var new_card := draw_card()

	var index := hand.get_children().find(card)

	hand.remove_child(card)
	deck.append(card)
	
	# put the card back, replacing the position of the one that was played
	hand.add_child(new_card)
	hand.move_child(new_card, index)
	
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
			yield(get_tree(), "idle_frame")
			if get_enemy_count() == 0:
				emit_signal("complete")

func get_screen_pos(field_pos: Vector2) -> Vector2:
	return platform_grid.rect_position + field_pos * platform_separation

func _on_SlimeMoveTimer_timeout():
	var slimes := []
	
	for ent in field.get_children():
		if ent is Slime:
			slimes.append(ent)
	
	slimes.sort_custom(self, "sort_by_distance_to_player")
	
	for i in slimes:
		var slime: Entity = i
		var dir := slime.field_pos.direction_to(player.field_pos)
		var new_pos := slime.field_pos + Helpers.vec_to_nearest_cardinal(dir)
		var other := try_move_entity(slime, new_pos)
		if other == player:
			pass # TODO: damage player


func sort_by_distance_to_player(a: Entity, b: Entity) -> bool:
	return player.field_pos.distance_to(a.field_pos) < player.field_pos.distance_to(b.field_pos)
