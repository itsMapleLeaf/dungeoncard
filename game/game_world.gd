extends Node
class_name GameWorld

const map_size := 7
var grid := Grid.new(Vector2(map_size, map_size))
var entity_positions := {}

func register_entity_at_random_pos(entity: Node) -> void:
	var pos := random_map_pos()
	grid.set_item(pos, entity)
	entity_positions[entity] = pos

func get_map_pos(entity: Node) -> Vector2:
	return entity_positions[entity] as Vector2

func try_move(entity: Node, direction: Vector2) -> void:
	var pos := entity_positions[entity] as Vector2
	if pos == null: return

	var new_pos := pos + direction
	if not grid.is_in_range(new_pos): return
	if grid.has_item(new_pos): return

	grid.move_item(pos, new_pos)
	entity_positions[entity] = new_pos

func random_map_pos() -> Vector2:
	return Vector2(randi() % map_size, randi() % map_size)
