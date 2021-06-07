extends Node
class_name Helpers

static func random_item(array: Array):
	return array[randi() % array.size()]

static func reparent(child: Node, old_parent: Node, new_parent: Node) -> void:
	old_parent.remove_child(child)
	new_parent.add_child(child)
