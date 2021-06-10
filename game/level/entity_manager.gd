extends Object
class_name EntityManager

var entities := []

func add_at(field_pos: Vector2, node: Node2D) -> Entity:
	var entity := Entity.new(field_pos, node)
	entities.append(entity)
	return entity
	
func remove(entity: Entity) -> void:
	entity.node.queue_free()
	entities.erase(entity)

func get_entity_at_position(field_pos: Vector2) -> Entity:
	for e in entities:
		if field_pos.is_equal_approx(e.field_pos):
			return e
			
	return null
	
func is_occupied(field_pos: Vector2) -> bool:
	return get_entity_at_position(field_pos) != null
	
func clear() -> void:
	for entity in entities:
		remove(entity)

class Entity:
	var field_pos: Vector2
	var node: Node2D
	
	func _init(field_pos: Vector2, node: Node2D) -> void:
		self.field_pos = field_pos
		self.node = node
