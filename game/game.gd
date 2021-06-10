extends Node2D

var level: Level

func _ready():
	create_level()
	
func create_level():
	if level: level.queue_free()
	
	level = load("res://game/level/level.tscn").instance()
	add_child(level)
	level.connect("complete", self, "create_level")
