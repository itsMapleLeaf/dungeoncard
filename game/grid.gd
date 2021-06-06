class_name Grid

var cells := []
var size: Vector2

func _init(size: Vector2) -> void:
	self.size = size
	
	for y in size.y:
		cells.append([])
		for x in size.x:
			cells[y].append(null)

func is_in_range(pos: Vector2) -> bool:
	return pos.x >= 0 and pos.x < size.x and pos.y >= 0 and pos.y < size.y

func get_item(pos: Vector2) -> Object:
	if !is_in_range(pos): return null
	return cells[pos.y][pos.x]
	
func set_item(pos: Vector2, item: Object) -> void:
	if !is_in_range(pos): return
	cells[pos.y][pos.x] = item

func has_item(pos: Vector2) -> bool:
	return get_item(pos) != null

func move_item(old_pos: Vector2, new_pos: Vector2) -> void:
	var item = get_item(old_pos)
	set_item(old_pos, null)
	set_item(new_pos, item)
