extends Node
class_name Helpers

static func random_item(array: Array):
	return array[randi() % array.size()]

static func reparent(child: Node, old_parent: Node, new_parent: Node) -> void:
	old_parent.remove_child(child)
	new_parent.add_child(child)

static func points_within_rect(rect: Rect2) -> Array:
	var points := []
	
	for x in rect.size.x: for y in rect.size.y:
		points.append(rect.position + Vector2(x, y))
	
	return points
